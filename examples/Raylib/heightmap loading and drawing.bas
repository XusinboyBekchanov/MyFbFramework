#include "inc/raylib.bi"
'https://raylibtech.itch.io/rguilayout
'https://github.com/Rabios/awesome-raylib
#define MAX_COLUMNS 20

Dim As Integer screen_width = 1920
Dim As Integer screen_height = 1080
SetConfigFlags(FLAG_WINDOW_RESIZABLE Or FLAG_WINDOW_HIGHDPI )
'SetConfigFlags(IFLAG_WINDOW_UNDECORATED)
InitWindow(screen_width, screen_height, "raylib [models] example - heightmap loading and drawing")

Dim As Camera cam
cam.position = Vector3(4.0, 2.0, 4.0)
cam.target = Vector3(0, 1.8, 0)
cam.up = Vector3(0, 1, 0)
cam.fovy = 60
cam.projection = CAMERA_PERSPECTIVE

Dim As Short heights(MAX_COLUMNS)
Dim As Vector3 positions(MAX_COLUMNS)
Dim As ColorRL col(MAX_COLUMNS)

For i As Integer = 0 To MAX_COLUMNS
	heights(i) = GetRandomValue(1, 12)
	positions(i) = Vector3(GetRandomValue(-15, 15), heights(i)/2.0, GetRandomValue(-15, 15))
	col(i) = ColorRL(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255)
Next i

'SetCameraMode(cam, CAMERA_FIRST_PERSON)
'SetCameraMode(cam, 1)
SetTargetFPS(60)

While Not WindowShouldClose()
	
	UpdateCamera(@cam, 1)
	
	BeginDrawing()
	
	ClearBackground(RAYWHITE)
	
	BeginMode3D(cam)
	
	DrawPlane(Vector3(0.0, 0.0, 0.0), Vector2(32.0, 32.0), LIGHTGRAY)
	DrawCube(Vector3(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, BLUE)
	DrawCube(Vector3(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, LIME)
	DrawCube(Vector3(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, GOLD)
	
	For j As Integer = 0 To MAX_COLUMNS
		DrawCube(positions(j), 2.0, heights(j), 2.0, col(j))
		DrawCubeWires(positions(j), 2.0, heights(j), 2.0, MAROON)
	Next j
	'DrawGrid(20, 1.0f)
	EndMode3D()
	
	DrawRectangle( 10, 10, 220, 70, Fade(SKYBLUE, 0.5))
	DrawRectangleLines( 10, 10, 220, 70, BLUE)
	
	DrawText("First person camera default controls:", 20, 20, 10, BLACK)
	DrawText("- Move with keys: W, A, S, D", 40, 40, 10, DARKGRAY)
	DrawText("- Mouse move to look around", 40, 60, 10, DARKGRAY)
	
	
	EndDrawing()
Wend

CloseWindowRL()
