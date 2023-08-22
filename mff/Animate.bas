'###############################################################################
'#  Animate.bas                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TAnimate.bas                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#   Updated and added cross-platform code                                     #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "Animate.bi"
Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function Animate.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "autoplay": Return @FAutoPlay
			Case "autosize": Return @FAutoSize
			Case "center": Return @FCenter
			Case "commonavi": Return @FCommonAvi
			Case "file": Return FFile
			Case "repeat": Return @FRepeat
			Case "startframe": Return @FStartFrame
			Case "stopframe": Return @FStopFrame
			Case "timers": Return @FTimers
			Case "ratiofixed": Return @FRatioFixed
			Case "rate": Return @FRate
			Case "transparency": Return @FTransparent
			Case "position": Return @FPosition
				#ifndef __USE_GTK__
					#ifdef MoviePlayOn
					Case "balance": Return @FBalance
					Case "volume": Return @FVolume
					Case "fullscreenmode": Return @FFullScreenMode
					Case "igraphbuilder": Return pGraph
					Case "imediacontrol": Return PControl
					Case "imediaevent": Return pEvent
					Case "ivideowindow": Return VidWindow
					Case "imediaseeking": Return MedSeek
					Case "imediaposition": Return MedPosition
					Case "ibasicvideo": Return BasVideo
					Case "ibasicaudio": Return BasAudio
					#endif
				#endif
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Animate.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "autoplay": AutoPlay = QBoolean(Value)
			Case "autosize": AutoSize = QBoolean(Value)
			Case "center": Center = QBoolean(Value)
			Case "commonavi": CommonAvi = *Cast(CommonAVIs Ptr, Value)
			Case "file": File = QWString(Value)
			Case "repeat": Repeat = QInteger(Value)
			Case "startframe": StartFrame = QLong(Value)
			Case "stopframe": StopFrame = QLong(Value)
			Case "timers": Timers = QBoolean(Value)
			Case "rate": Rate = QDouble(Value)
			Case "transparency": Transparency = QBoolean(Value)
			Case "position": Position = QDouble(Value)
				#ifndef __USE_GTK__
					#ifdef MoviePlayOn
					Case "balance": Balance = QDouble(Value)
					Case "volume": Volume = QLong(Value)
					Case "fullscreenmode": FullScreenMode = QLong(Value)
					Case "igraphbuilder": pGraph = Cast(IGraphBuilder Ptr, Value)
					Case "imediacontrol": PControl = Cast(IMediaControl Ptr, Value)
					Case "imediaevent": pEvent = Cast(IMediaEvent Ptr, Value)
					Case "ivideowindow": VidWindow = Cast(IVideoWindow Ptr, Value)
					Case "imediaseeking": MedSeek = Cast(IMediaSeeking Ptr, Value)
					Case "imediaposition": MedPosition = Cast(IMediaPosition Ptr, Value)
					Case "ibasicvideo":  BasVideo = Cast(IBasicVideo Ptr, Value)
					Case "ibasicaudio":  BasAudio = Cast(IBasicAudio Ptr, Value)
					#endif
				#endif
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property Animate.Center As Boolean
		Return FCenter
	End Property
	
	Private Property Animate.Center(Value As Boolean)
		If FCenter <> Value Then FCenter = Value Else Return
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or SS_OWNERDRAW Or ACenter(abs_(FCenter)) Or ATransparent(abs_(FTransparent)) Or ATimer(abs_(FTimers)) Or AAutoPlay(abs_(FAutoPlay))
		#endif
	End Property
	
	Private Property Animate.Transparency As Boolean
		Return FTransparent
	End Property
	
	Private Property Animate.Transparency(Value As Boolean)
		If FTransparent <> Value Then FTransparent = Value Else Return
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or SS_OWNERDRAW Or ACenter(abs_(FCenter)) Or ATransparent(abs_(FTransparent)) Or ATimer(abs_(FTimers)) Or AAutoPlay(abs_(FAutoPlay))
		#endif
	End Property
	
	Private Property Animate.Timers As Boolean
		Return FTimers
	End Property
	
	Private Property Animate.Timers(Value As Boolean)
		If FTimers <> Value Then FTimers = Value Else Return
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or SS_OWNERDRAW Or ACenter(abs_(FCenter)) Or ATransparent(abs_(FTransparent)) Or ATimer(abs_(FTimers)) Or AAutoPlay(abs_(FAutoPlay))
		#endif
	End Property
	
	Private Property Animate.File ByRef As WString
		If FFile> 0 Then Return *FFile Else Return ""
	End Property
	
	Private Property Animate.File(ByRef Value As WString)
		FFile = _Reallocate(FFile, (Len(Value) + 1) * SizeOf(WString))
		*FFile = Value
		#ifdef __USE_GTK__
			pixbuf_animation = gdk_pixbuf_animation_new_from_file(ToUtf8(*FFile), NULL)
		#else
			If Handle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle(NULL))
			End If
		#endif
	End Property
	
	Private Property Animate.Repeat As Integer
		Return FRepeat
	End Property
	
	Private Property Animate.Repeat(Value As Integer)
		FRepeat = Value
	End Property
	
	Private Property Animate.AutoPlay As Boolean
		Return FAutoPlay
	End Property
	
	Private Property Animate.AutoPlay(Value As Boolean)
		If FAutoPlay <> Value Then FAutoPlay = Value Else Return
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or SS_OWNERDRAW Or ACenter(abs_(FCenter)) Or ATransparent(abs_(FTransparent)) Or ATimer(abs_(FTimers)) Or AAutoPlay(abs_(FAutoPlay))
		#endif
	End Property
	
	Private Property Animate.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Private Property Animate.AutoSize(Value As Boolean)
		FAutoSize = Value
	End Property
	
	Private Property Animate.CommonAvi As CommonAVIs
		Return FCommonAvi
	End Property
	
	Private Property Animate.CommonAvi(Value As CommonAVIs)
		FCommonAvi = Value
		#ifndef __USE_GTK__
			If Handle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle("Shell32"))
			End If
		#endif
	End Property
	
	Private Property Animate.Volume As Long
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If BasAudio > 0 Then IBasicAudio_get_Volume(BasAudio, @FVolume)
			#endif
		#endif
		Return FVolume
	End Property
	
	Private Property Animate.Volume(Value As Long)
		If FVolume <> Value Then FVolume = Value Else Return
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If BasAudio > 0 Then IBasicAudio_put_Volume(BasAudio, FVolume)
			#endif
		#endif
	End Property
	
	Private Property Animate.Balance As Long
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If BasAudio > 0 Then IBasicAudio_get_Balance(BasAudio, @FBalance)
			#endif
		#endif
		Return FBalance
	End Property
	
	Private Property Animate.Balance(Value As Long)
		If FBalance <> Value Then FBalance = Value Else Return
		FBalance = Value
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If BasAudio > 0 Then IBasicAudio_put_Balance(BasAudio, FBalance)
			#endif
		#endif
	End Property
	
	Private Property Animate.FullScreenMode As Boolean
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If VidWindow > 0 Then
					If IVideoWindow_get_FullScreenMode(VidWindow, @FFullScreenMode) < 0 Then FFullScreenMode = OAFALSE
				End If
				Return IIf(FFullScreenMode = OATRUE, True, False)
			#else
				Return CBool(FFullScreenMode)
			#endif
		#else
			Return CBool(FFullScreenMode)
		#endif
	End Property
	
	Private Property Animate.FullScreenMode(Value As Boolean)
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				FFullScreenMode = IIf(Value= True, OATRUE, OAFALSE)
				If VidWindow > 0 Then IVideoWindow_put_FullScreenMode(VidWindow, FFullScreenMode)
			#endif
		#endif
	End Property
	
	Private Property Animate.Rate As Double
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If MedSeek > 0 Then IMediaSeeking_GetRate(MedSeek, @FRate)
			#endif
		#endif
		Return FRate
	End Property
	
	Private Property Animate.Rate(Value As Double)
		If FRate <> Value Then FRate = Value Else Return
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				If MedSeek > 0 Then IMediaSeeking_SetRate(MedSeek, FRate)
			#endif
		#endif
	End Property
	
	Private Property Animate.Position As Double
		#ifndef __USE_GTK__
			If FOpenMode= 3 Then
				#ifdef MoviePlayOn
					If MedPosition > 0 Then IMediaPosition_get_CurrentPosition(MedPosition, @FPosition)
				#endif
			ElseIf FOpenMode= 4 Then
				#ifdef GIFPlayOn
					'This is work with outer TimerComponent
					If Not gifDrawing AndAlso FPlay AndAlso Timer - FPlayTimeFramStart > FFrameDelays(FFrameIndex) / FRate/ 1000 Then
						'If Not GIFDrawing Then
						Dim As Message MSGPlay
						MSGPlay.Msg = WM_PAINT
						ProcessMessage(MSGPlay)
						FPosition = FFrameIndex
						FFrameIndex += 1
						If FFrameCount <= 1 OrElse FFrameIndex > FFrameCount - 1  Then FFrameIndex = 0
					End If
				#endif
			Else
				If FPlay Then
					FPosition = Timer - FPlayTimeStart - FPlayTimePause
				Else
					FPosition = Timer - FPlayTimeStart - (FPlayTimePause+ (Timer - FPlayTimePauseStart))
				End If
			End If
		#endif
		Return FPosition
	End Property
	
	Private Property Animate.Position(Value As Double)
		If FPosition <> Value Then FPosition = Value Else Return
		#ifndef __USE_GTK__
			If FOpenMode= 3  Then
				#ifdef MoviePlayOn
					If MedPosition > 0 Then IMediaPosition_put_CurrentPosition(MedPosition, FPosition)
				#endif
			End If
		#endif
	End Property
	
	Private Property Animate.StartFrame As Long
		Return FStartFrame
	End Property
	
	Private Property Animate.StartFrame(Value As Long)
		FStartFrame = Value
		If FStartFrame < 0 Then FStartFrame = 0
		If FPlay Then This.Stop
		Play
	End Property
	
	Private Property Animate.StopFrame As Long
		Return FStopFrame
	End Property
	
	Private Property Animate.StopFrame(Value As Long)
		FStopFrame = Value
		If FStopFrame > FFrameCount - 1 OrElse FStopFrame< 1 Then FStopFrame = FFrameCount
		If FPlay Then This.Stop
		Play
	End Property
	
	Private Function Animate.FrameCount As Long
		Return FFrameCount
	End Function
	
	Private Function Animate.OpenMode As Integer
		Return FOpenMode
	End Function
	
	Private Sub Animate.SetMoviePosition(ByVal ALeft As Long, ByVal ATop As  Long, ByVal AWidth As Long, ByVal AHeight As Long)
		#ifndef __USE_GTK__
			If FAutoSize Then
				FFrameWidth = ScaleX(AWidth) : FFrameHeight = ScaleY(AHeight)
				If FRatioFixed Then
					If FFrameWidth > FFrameHeight * FRatio Then
						FFrameWidth  = FFrameHeight * FRatio
					Else
						FFrameHeight  = FFrameWidth / FRatio
					End If
				End If
				If FCenter Then
					FFrameLeft = Max((ScaleX(AWidth) - FFrameWidth) / 2, 0) : FFrameTop = Max((ScaleY(AHeight) - FFrameHeight) / 2, 0)
				Else
					FFrameLeft = ScaleX(ALeft)  : FFrameTop = ScaleY(ATop)
				End If
				If FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If VidWindow > 0 Then IVideoWindow_SetWindowPosition(VidWindow, FFrameLeft, FFrameTop, FFrameWidth, FFrameHeight)
					#endif
				End If
			Else
				FFrameWidth = FFrameWidthOrig : FFrameHeight = FFrameHeightOrig
				If FCenter Then
					FFrameLeft = Max((ScaleX(AWidth) - FFrameWidth) / 2, 0) : FFrameTop = Max((ScaleY(AHeight) - FFrameHeight) / 2, 0)
				Else
					FFrameLeft = 0 : FFrameTop = 0
				End If
				If FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If VidWindow > 0 Then IVideoWindow_SetWindowPosition(VidWindow, FFrameLeft, FFrameTop, FFrameWidth, FFrameHeight)
					#endif
				End If
			End If
		#endif
	End Sub
	
	Private Property Animate.FrameHeight As Long
		Return FFrameHeight
	End Property
	
	Private Property Animate.FrameHeight(Value As Long)
		FFrameHeight = Value
		This.Height = UnScaleY(Value)
	End Property
	
	Private Property Animate.FrameWidth As Long
		Return FFrameWidth
	End Property
	
	Private Property Animate.FrameWidth(Value As Long)
		FFrameWidth = Value
		This.Width = UnScaleX(Value)
	End Property
	
	Private Function Animate.FrameHeightOriginal As Long
		Return FFrameHeightOrig
	End Function
	
	Private Function Animate.FrameWidthOriginal As Long
		Return FFrameWidthOrig
	End Function
	
	Private Function Animate.Ratio As Double
		Return FRatio
	End Function
	
	Private Property Animate.RatioFixed As Boolean
		Return FRatioFixed
	End Property
	
	Private Property Animate.RatioFixed(Value As Boolean)
		FRatioFixed = Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub Animate.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QAnimate(Sender.Child)
					SetClassLongPtr(.Handle, GCLP_HBRBACKGROUND, 0)
					If .FOpenMode Then .OpenFile
					If .FPlay Then .Play
				End With
			End If
		End Sub
		
		Private Sub Animate.WNDPROC(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
	
	'https://learn.microsoft.com/en-us/windows/win32/directshow/event-notification-codes.
	Private Sub Animate.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case ACN_START
					If OnStart Then OnStart(*Designer, This)
				Case ACN_STOP
					If OnStop Then OnStop(*Designer, This)
				End Select
			Case WM_NCHITTEST
				Message.Result = HTCLIENT
			Case WM_ERASEBKGND, WM_PAINT
				SetMoviePosition(0, 0, This.Width, This.Height)
				If FOpenMode = 4 Then
					#ifdef GIFPlayOn
						If FPlay AndAlso gifImagePtr > 0 Then
							gifDrawing = True
							Dim As ..Rect R
							Dim As HDC Dc
							Dim As PAINTSTRUCT Ps
							Dc = BeginPaint(Handle, @Ps)
							GdipCreateFromHDC(Dc, @gifGdipCanvas)
							GdipImageSelectActiveFrame(gifImagePtr, @FFrameList, FFrameIndex)
							GdipDrawImageRect(gifGdipCanvas, gifImagePtr, FFrameLeft, FFrameTop, FFrameWidth, FFrameHeight) 'copy frame to GDI canvas
							If OnPaint Then OnPaint(This, Canvas)
							EndPaint Handle, @Ps
							DeleteDC(Dc)
							'Message.Result = 0
							GetClientRect Handle, @R
							gifDrawing = False
							InvalidateRect(Handle, @R, 0)
							FPlayTimeFramStart = Timer
							Exit Sub
						End If
					#endif
				End If
			Case WM_NCPAINT
				'Dim As HDC Dc
				'Dc = GetDCEx(Handle, 0, DCX_WINDOW Or DCX_CACHE Or DCX_CLIPSIBLINGS)
				'Future utilisation
				'ReleaseDC Handle,Dc
				
				#ifdef MoviePlayOn
				Case 70, 32 'WM_USER + 13 'WM_GRAPHNOTIFY
					If pEvent > 0 Then
						Dim hr As HRESULT
						Dim lEventCode As Long
						Dim lParam1 As LONG_PTR
						Dim lParam2 As LONG_PTR
						hr = pEvent->lpVtbl->GetEvent(pEvent, @lEventCode, @lParam1, @lParam2, 0)
						If hr = S_OK Then
							pEvent->lpVtbl->FreeEventParams(pEvent, lEventCode, lParam1, lParam2)
							Message.Msg = WM_USER + 13 '
							Message.lParamLo = lEventCode
						End If
					End If
				#endif
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Function Animate.OpenFile(ByRef FileName As WString = "") As Integer
		FErrorInfo = ""
		FOpenMode = 0: FRate= 1
		If Trim(FileName) <> "" Then WLet(FFile, FileName)
		#ifdef __USE_GTK__
			If OnOpen Then OnOpen(*Designer, This)
			If pixbuf_animation <> 0 Then
				FFrameWidth = gdk_pixbuf_animation_get_width(pixbuf_animation)
				FFrameHeight = gdk_pixbuf_animation_get_height(pixbuf_animation)
			End If
			FOpenMode= 1
			If FAutoPlay Then
				Play
			Else
				'				If pixbuf_animation <> 0 Then
				'					gtk_image_set_from_pixbuf(gtk_image(widget), gdk_pixbuf_animation_get_static_image(pixbuf_animation))
				'				End If
			End If
		#else
			If Handle Then
				If OnOpen Then OnOpen(*Designer, This)
				If FPlay Then Stop
				If CommonAvi = 0 Then
					If *FFile <> "" Then
						If StartsWith(*FFile, "./") OrElse StartsWith(*FFile, ".\") Then
							WLetEx FFile, ExePath & Mid(*FFile, 2), True
						End If
						#ifdef GIFPlayOn
							gifInterval = -1
							If LCase(Right(Trim(*FFile), 4)) = ".gif" Then
						#else
							If False Then
						#endif
							#ifdef GIFPlayOn
								If gifImagePtr > 0 Then GdiplusShutdown(gdipToken)
								If Dir(*FFile) = "" Then
									FErrorInfo = "File not exist! " & *FFile
									Return FOpenMode
								End If
								GDIp.GdiplusVersion = 1
								If GdiplusStartup(@gdipToken, @GDIp, NULL) <> 0 Then Return FOpenMode
								If GdipLoadImageFromFile(*FFile, @gifImagePtr) <> 0 Then GdiplusShutdown(gdipToken) : Return FOpenMode
								If GdipGetImageDimension(gifImagePtr, @FFrameWidthOrig, @FFrameHeightOrig) <> 0 Then GdiplusShutdown(gdipToken) : Return FOpenMode   'get GIF anim dimension
								If FFrameWidthOrig = 0 Then
									GdiplusShutdown(gdipToken)
									FErrorInfo = "Something went wrong to load the GIF animation!"
									Return FOpenMode
								End If
								gifDrawing = False
								FFrameIndex = 0
								FRatio = FFrameWidthOrig / FFrameHeightOrig
								FFrameWidth = FFrameWidthOrig : FFrameHeight = FFrameHeightOrig
								Dim As ULong FFrameIndexDimCount
								If (GdipImageGetFrameDimensionsCount(gifImagePtr, @FFrameIndexDimCount)) <> 0 Then GdiplusShutdown(gdipToken) : Return FOpenMode
								If (GdipImageGetFrameDimensionsList(gifImagePtr, @FFrameList, FFrameIndexDimCount)) <> 0 Then GdiplusShutdown(gdipToken) : Return FOpenMode
								If (GdipImageGetFrameCount(gifImagePtr, @FFrameList, @FFrameIndexDimCount)) <> 0 Then GdiplusShutdown(gdipToken) : Return FOpenMode
								FFrameCount = FFrameIndexDimCount
								ReDim FFrameDelays(0 To FFrameCount - 1)
								Dim As ULong iSize
								GdipGetPropertyItemSize(gifImagePtr, PropertyTagFrameDelay, @iSize)
								Dim As PropertyItem Ptr gifPropItem = _Allocate(iSize * SizeOf(PropertyItem))
								GdipGetPropertyItem(gifImagePtr, PropertyTagFrameDelay, iSize, @gifPropItem[0])
								
								Select Case gifPropItem->type
								Case 1
									Dim As UByte Ptr delay = gifPropItem->value
									For i As ULong = 0 To UBound(FFrameDelays)
										FFrameDelays(i) = delay[i] * 10
										gifInterval = Min(gifInterval, delay[i] * 10)
									Next
								Case 3
									Dim As UShort Ptr delay = gifPropItem->value
									For i As ULong = 0 To UBound(FFrameDelays)
										FFrameDelays(i) = delay[i] * 10
										gifInterval = Min(gifInterval, delay[i] * 10)
									Next
								Case 4
									Dim As ULong Ptr delay = gifPropItem->value
									For i As ULong = 0 To UBound(FFrameDelays)
										FFrameDelays(i) = delay[i] * 10
										gifInterval = Min(gifInterval, delay[i] * 10)
									Next
								End Select
								Print  "FFrameWidth=" & FFrameWidth & "  FFrameHeight=" &  FFrameHeight
								'Print  "BitsPerPixel=" & gifImagePtr->SColorMap->BitsPerPixel & " SBackGroundColor=" & gifImagePtr->SBackGroundColor
								FOpenMode= 4
								SetBounds(This.Left, This.Top, UnScaleX(FFrameWidth), UnScaleY(FFrameHeight))
								If FAutoPlay Then Play
							#endif
						ElseIf Perform(ACM_OPENW, 0, CInt(FFile)) <> 0 Then
							FOpenMode= 2
							Dim As Integer Ptr Buff = _Allocate(18*SizeOf(Integer))
							Dim As Integer F = FreeFile_
							Open *FFile For Binary Access Read As #F
							Get #F, , *Buff, 18
							CloseFile_(F)
							FFrameCount  = Buff[12]
							FFrameWidth  = Buff[16]
							FFrameHeight = Buff[17]
							If FFrameCount > 10000 OrElse FFrameCount < 0 Then FFrameCount = 1
							If FFrameHeight > 0 Then FRatio = FFrameWidth / FFrameHeight Else FRatio = 1
							FFrameWidthOrig = FFrameWidth : FFrameHeightOrig = FFrameHeight
							FStopFrame= FFrameCount
							FPlayTimeStart = Timer
							FPlayTimePauseStart = Timer
							FPlayTimePause= 0
							If FAutoPlay Then Play
						Else
							#ifdef MoviePlayOn
								If pGraph = 0 Then
									Error_HR(CoInitialize(0), "CoInitialize")
									Error_HR(CoCreateInstance(@CLSID_FilterGraph, NULL, CLSCTX_ALL, @IID_IGraphBuilder, @pGraph), "CoCreateInstance")
								End If
								If pGraph > 0 Then
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaControl, @PControl  ), "IMediaControl")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaEvent  , @pEvent    ), "IMediaEvent")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IVideoWindow , @VidWindow ), "IVideoWindow")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaSeeking, @MedSeek   ), "IMediaSeeking")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IMediaPosition, @MedPosition), "IMediaPosition")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IBasicVideo  , @BasVideo  ), "IBasicVideo")
									Error_HR(IGraphBuilder_QueryInterface(pGraph, @IID_IBasicAudio  , @BasAudio  ), "IBasicAudio")
									'For MKV. MP4, Need Install decoding package like LAV
									'If can't Render File install LAV from https://github.com/Nevcairiel/LAVFilters/releases"
									If PControl > 0 Then Error_HR(IMediaControl_RenderFile(PControl, StrPtr(*FFile)), "RenderFile, decoding, path, or Internet issue.")
									If MedPosition > 0 Then IMediaPosition_get_Duration(MedPosition, @FFrameCount)
									If BasVideo > 0 Then
										IBasicVideo_get_SourceWidth(BasVideo, @FFrameWidth)
										IBasicVideo_get_SourceHeight(BasVideo, @FFrameHeight)
									End If
									If FFrameHeight > 0 Then FRatio = FFrameWidth / FFrameHeight Else FRatio = 1
									FFrameWidthOrig = FFrameWidth : FFrameHeightOrig = FFrameHeight
									If VidWindow > 0 Then
										IVideoWindow_put_Owner(VidWindow, Cast(OAHWND, FHandle))
										IVideoWindow_put_WindowStyle(VidWindow, WS_CHILD Or SS_OWNERDRAW)
									End If
									FOpenMode= 3
									If FAutoPlay Then Play
								End If
							#else
								FErrorInfo =  "Can not open the movie file! Or add code -  #define GIFMovieOn"
							#endif
						End If
					End If
				Else
					If FindResource(GetModuleHandle("Shell32"), MAKEINTRESOURCE(FCommonAvi), "AVI") Then
						*FFile = ""
						If Perform(ACM_OPEN, CInt(GetModuleHandle("Shell32")), CInt(MAKEINTRESOURCE(FCommonAvi))) = 0 Then
							FErrorInfo =  "Can not play the Resource " & FCommonAvi
							Return 0
						Else
							Dim As HRSRC Resource
							Dim As HGLOBAL Global
							Dim As Any Ptr PResource
							Dim As UByte Ptr P
							Dim As Integer Size
							Dim As Integer Ptr Buff = _Allocate(18*SizeOf(Integer))
							Resource  = FindResource(GetModuleHandle("Shell32"),MAKEINTRESOURCE(FCommonAvi),"AVI")
							Global    = LoadResource(GetModuleHandle("Shell32"),Resource)
							PResource = LockResource(Global)
							Size = SizeofResource(GetModuleHandle("Shell32"), Resource)
							P = _Allocate(Size)
							P = PResource
							FreeResource(Resource)
							memcpy Buff, P, 18 * SizeOf(Integer)
							FFrameCount  = 100 'Buff[12]
							FFrameWidth  = Buff[16]
							FFrameHeight = Buff[17]
							If FFrameCount > 7200 OrElse FFrameCount < 0 Then FFrameCount = 100
							FFrameWidthOrig = FFrameWidth : FFrameHeightOrig = FFrameHeight
							If FFrameHeight > 0 Then FRatio = FFrameWidth / FFrameHeight Else FRatio = 1
							FStartFrame= 0 : FStopFrame= IIf(FFrameCount > 0, FFrameCount, 10)
							Print " FFrameCount=" & FFrameCount & " FFrameWidth=" & FFrameWidth & " FFrameHeight=" & FFrameHeight & " FCommonAvi=" & FCommonAvi
							FOpenMode= 1
							FPlayTimeStart = Timer
							FPlayTimePauseStart = Timer
							FPlayTimePause= 0
							If FAutoPlay Then Play
						End If
					Else
						FErrorInfo = "CommonAvi.Open not find the resource"
						Return FOpenMode
					End If
				End If
			End If
		#endif
		Return FOpenMode
	End Function
	
	Private Function Animate.GetErrorInfo As String
		Return FErrorInfo
	End Function
	
	Private Function Animate.IsPlaying As Boolean
		#ifdef __USE_GTK__
			Return FPlay
		#else
			If FOpenMode= 3 Then
				#ifdef MoviePlayOn
					If PControl Then Return FPlay
				#endif
			Else
				Return FPlay
				'Return Perform(ACM_ISPLAYING, 0, 0)
			End If
		#endif
	End Function
	
	Private Sub Animate.Play
		FErrorInfo = ""
		#ifdef __USE_GTK__
			If pixbuf_animation <> 0 Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				iter = gdk_pixbuf_animation_get_iter(pixbuf_animation, @gTime)
				If OnStart Then OnStart(*Designer, This)
				FPlay = True
				Timer_cb(@This)
			End If
		#else
			If Handle Then
				If FPlayTimeStart = 0 Then
					FPlayTimeStart = Timer
				Else
					FPlayTimePause += Timer - FPlayTimePauseStart
				End If
				If OnStart Then OnStart(*Designer, This)
				If FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If PControl > 0 Then Error_HR(IMediaControl_Run(PControl), "Metod IMediaControl_Run")
					#endif
				ElseIf FOpenMode < 3 Then
					Print "FFrameCount=" & FFrameCount & " FStartFrame=" &  FStartFrame & " FStopFrame=" & FStopFrame & " FRepeat=" & FRepeat
					If FStopFrame < 1 Then FStopFrame= FFrameCount
					Perform(ACM_PLAY, FRepeat, MAKELONG(FStartFrame, FStopFrame))
				End If
				FPlay = True
			End If
		#endif
	End Sub
	
	Private Sub Animate.Stop
		FErrorInfo = ""
		#ifdef __USE_GTK__
			If OnStop Then OnStop(*Designer, This)
			FPlay = False
		#else
			If FOpenMode Then
				FPlayTimeStart = 0
				FPlayTimePause = 0
				If OnStop Then OnStop(*Designer, This)
				If FOpenMode= 4 Then
					#ifdef GIFPlayOn
						GdipDeleteGraphics(gifGdipCanvas)
						GdipDisposeImage(gifImagePtr)
						GdiplusShutdown(gdipToken)
					#endif
				ElseIf FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If PControl Then Error_HR(IMediaControl_Stop(PControl), "Metod IMediaControl_Stop")
						If PControl > 0 Then IMediaControl_Release(PControl)
						If pEvent > 0 Then IMediaEvent_Release  (pEvent)
						If VidWindow > 0 Then IVideoWindow_Release (VidWindow)
						If MedSeek > 0 Then IMediaSeeking_Release(MedSeek)
						If MedPosition > 0 Then IMediaPosition_Release(MedPosition)
						If BasVideo > 0 Then IBasicVideo_Release  (BasVideo)
						If BasAudio > 0 Then IBasicAudio_Release  (BasAudio)
						If pGraph > 0 Then IGraphBuilder_Release(pGraph)
						pGraph = 0
						PControl = 0
						pEvent = 0
						VidWindow = 0
						MedSeek = 0
						MedPosition = 0
						BasVideo = 0
						BasAudio = 0
						CoUninitialize()
					#endif
				Else
					Perform(ACM_STOP, 0, 0)
					Perform(ACM_OPENW, 0, 0)
				End If
				FCommonAvi = 0
				FOpenMode = 0
				*FFile = ""
				FPlay = False
			End If
		#endif
	End Sub
	
	Private Sub Animate.Pause
		FErrorInfo = ""
		Rate = 1
		#ifdef __USE_GTK__
			If OnPause Then OnPause(*Designer, This)
			FPlay = False
		#else
			If Handle Then
				FPlayTimePauseStart = Timer
				If OnPause Then OnPause(*Designer, This)
				If FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If PControl Then Error_HR(IMediaControl_Pause(PControl), "Metod IMediaControl_Pause")
					#endif
				Else
					Perform(ACM_STOP, 0, 0)
				End If
				FPlay = False
			End If
		#endif
	End Sub
	Private Sub Animate.Close
		FErrorInfo = ""
		#ifdef __USE_GTK__
			If OnClose Then OnClose(*Designer, This)
			FOpenMode= 0
			FPlay = False
		#else
			If Handle Then
				FPlayTimeStart = 0
				FPlayTimePause = 0
				If OnClose Then OnClose(*Designer, This)
				If FOpenMode= 4 Then
					#ifdef GIFPlayOn
						Stop
					#endif
				ElseIf FOpenMode= 3 Then
					#ifdef MoviePlayOn
						If PControl Then
							Stop
						End If
					#endif
				Else
					Perform(ACM_STOP, 0, 0)
					Perform(ACM_OPENW, 0, 0)
				End If
				FOpenMode = 0
				FCommonAvi = 0
				*FFile = ""
				FPlay = False
			End If
		#endif
	End Sub
	
	Private Operator Animate.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Function Animate.Timer_cb(ByVal user_data As gpointer) As gboolean
			Dim As Animate Ptr anim = user_data
			If anim->FPlay Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				gdk_pixbuf_animation_iter_advance(anim->iter, @gTime)
				g_timeout_add(gdk_pixbuf_animation_iter_get_delay_time(anim->iter), Cast(GSourceFunc, @Timer_cb), user_data)
				gtk_widget_queue_draw(anim->widget)
			End If
			Return False
		End Function
		
		Private Function Animate.DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Animate Ptr anim = data1
			#ifdef __USE_GTK3__
				Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
			#else
				Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
			#endif
			If anim->FDesignMode Then
				cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
				Dim As Double Ptr dashed = _Allocate(SizeOf(Double) * 2)
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
		
		Private Function Animate.DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			DesignDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Sub Animate.Screen_Changed(widget As GtkWidget Ptr, old_screen As GdkScreen Ptr, userdata As gpointer)
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
	#else
		#ifdef MoviePlayOn
			Private Function Animate.Error_HR(ByVal hr As Integer, ByRef Inter_face As WString) As Integer
				If (FAILED(hr)) Then
					FErrorInfo = "Error associated with " & Inter_face & ". ERROR CODE: " & hr
					Var MB = MessageBox(0, "Error associated with " & Inter_face & ". Want Continue?", "Error", MB_YESNO)
					If MB = IDNO Then
						End
					End If
				Else
					Return 1
				End If
			End Function
		#endif
	#endif
	
	Private Constructor Animate
		Dim As Boolean Result
		#ifdef __USE_GTK__
			widget = gtk_image_new()
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(GTK_CONTAINER(eventboxwidget), widget)
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
			Result = INITCOMMONCONTROLSEX(@ICC)
			If Not Result Then InitCommonControls
			ACenter(0)      = 0
			ACenter(1)      = ACS_CENTER
			ATransparent(0) = 0
			ATransparent(1) = ACS_TRANSPARENT
			ATimer(0)       = 0
			ATimer(1)       = ACS_TIMER
			AAutoPlay(0)    = 0
			AAutoPlay(1)    = ACS_AUTOPLAY
		#endif
		FRepeat         = -1
		FRate           = 1
		FStopFrame      = -1
		FStartFrame     = 0
		FCenter = True
		FRatioFixed = True
		FTransparent = True
		FAutoSize = True
		FAutoPlay = True
		FTimers = True
		With This
			WLet(FClassName, "Animate")
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "Animate", ANIMATE_CLASS
				.ChildProc         = @WNDPROC
				WLet(FClassAncestor, ANIMATE_CLASS)
				.ExStyle           = WS_EX_TRANSPARENT
				.Style             = WS_CHILD Or SS_OWNERDRAW Or ACenter(abs_(FCenter)) Or ATransparent(abs_(FTransparent)) Or ATimer(abs_(FTimers)) Or AAutoPlay(abs_(FAutoPlay))
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width             = 100
			.Height            = 80
		End With
	End Constructor
	
	Private Destructor Animate
		If FFile Then _Deallocate( FFile)
		#ifndef __USE_GTK__
			#ifdef MoviePlayOn
				Stop
			#endif
		#endif
	End Destructor
End Namespace
