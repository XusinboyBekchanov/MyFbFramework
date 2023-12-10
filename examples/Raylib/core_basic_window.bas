#include "inc/raylib.bi"

Dim As Integer screen_width = 800
Dim As Integer screen_height = 450

InitWindow(screen_width, screen_height, "raylib-freebasic [core] example - basic window")

'Audio
InitAudioDevice
Dim As Sound fxcountry = LoadSound("..\resources\country.mp3")
Dim As Sound fxWav = LoadSound("..\resources\sound.wav")
Dim As Sound fxOgg = LoadSound("..\resources\target.ogg")
Dim As Music fxMusic = LoadMusicStream("..\resources\country.mp3")

'Uicode
Dim As ZString Ptr StrShow = @"恭喜!您创建了第一个窗口!"
'读取字体文件
Dim As Long fileSize
Dim As UByte Ptr fontFileData = LoadFileData("c:\windows\fonts\simhei.ttf", @fileSize)

SetTargetFPS(60)
'PlayMusicStream(fxMusic)
While Not WindowShouldClose()
	'Print IsKeyPressed(KEY_SPACE)
	If IsKeyPressed(KEY_SPACE) Then PlaySound fxWav
	If IsKeyDown(KEY_ENTER) Then PlaySound fxOgg
	If IsKeyPressed(KEY_P) Then PlayMusicStream(fxMusic)
	' Updates buffers for music streaming, this should be called on every frame
	UpdateMusicStream(fxMusic)
	'If GetMusicTimePlayed(fxMusic) > 0 Then Print "MusicTimePlayed"
	
	' 将字符串中的字符逐一转换成Unicode码点,得到码点表
	Dim As Long codepointsCount
	Dim As Long Ptr codepoints = LoadCodepoints(StrShow, @codepointsCount)
	' 读取仅码点表中各字符的字体
	Dim As Font FontShow = LoadFontFromMemory(".ttf", fontFileData, fileSize, 32, codepoints, codepointsCount)
	Dim As Vector2 PosiTion = Type<Vector2>(50, 50)
	' 释放码点表
	UnloadCodepoints(codepoints)
	
	'Draw
	BeginDrawing()
	ClearBackground(RAYWHITE)
	DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY)
	DrawTextEx(FontShow, StrShow, PosiTion, 32, 5, RED)
	EndDrawing()
Wend

UnloadMusicStream(fxMusic)
CloseAudioDevice
CloseWindow()
