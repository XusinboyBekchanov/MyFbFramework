#pragma once

#include once "crt/long.bi"
#include once "crt/stdarg.bi"

#inclib "raylib"

#if defined(__FB_CYGWIN__) Or defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__)
    #inclib "GL"
    #inclib "X11"
#endif

#ifdef __FB_LINUX__
    #inclib "dl"
    #inclib "rt"
#elseif defined(__FB_CYGWIN__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__)
    #inclib "Xrandr"
    #inclib "Xinerama"
    #inclib "Xi"
    #inclib "Xxf86vm"
    #inclib "Xcursor"
#elseif defined(__FB_DARWIN__)
    #inclib "OpenGL"
    #inclib "Cocoa"
#elseif defined(__FB_WIN32__)
    #inclib "opengl32"
    #inclib "gdi32"
    #inclib "winmm"
    #inclib "shell32"
#endif
Namespace RayLib
Extern "C"
#define RAYLIB_H
Const RAYLIB_VERSION_MAJOR = 5
Const RAYLIB_VERSION_MINOR = 1
Const RAYLIB_VERSION_PATCH = 0
#define RAYLIB_VERSION "5.1"
#ifndef NULL
	#define NULL 0
#endif
#ifndef PI
	Const PI = 3.14159265358979323846
#endif

Const DEG2RAD = PI / 180.0f
Const RAD2DEG = 180.0f / PI
#define RL_MALLOC(sz) malloc(sz)
#define RL_CALLOC(n, sz) calloc(n, sz)
#define RL_REALLOC(ptr, sz) realloc(ptr, sz)
#define RL_FREE(ptr) free(ptr)
#define RL_COLOR_TYPE
#define RL_Rectangle_TYPE
#define RL_VECTOR2_TYPE
#define RL_VECTOR3_TYPE
#define RL_VECTOR4_TYPE
#define RL_QUATERNION_TYPE
#define RL_MATRIX_TYPE

#define LIGHTGRAY ColorRL( 200, 200, 200, 255 )
#define GRAY ColorRL( 130, 130, 130, 255 )
#define DARKGRAY ColorRL( 80, 80, 80, 255 )
#define YELLOW ColorRL( 253, 249, 0, 255 )
#define GOLD ColorRL( 255, 203, 0, 255 )
#define ORANGE ColorRL( 255, 161, 0, 255 )
#define PINK ColorRL( 255, 109, 194, 255 )
#define RED ColorRL( 230, 41, 55, 255 )
#define MAROON ColorRL( 190, 33, 55, 255 )
#define GREEN ColorRL( 0, 228, 48, 255 )
#define LIME ColorRL( 0, 158, 47, 255 )
#define DARKGREEN ColorRL( 0, 117, 44, 255 )
#define SKYBLUE ColorRL( 102, 191, 255, 255 )
#define BLUE ColorRL( 0, 121, 241, 255 )
#define DARKBLUE ColorRL( 0, 82, 172, 255 )
#define PURPLE ColorRL( 200, 122, 255, 255 )
#define VIOLET ColorRL( 135, 60, 190, 255 )
#define DARKPURPLE ColorRL( 112, 31, 126, 255 )
#define BEIGE ColorRL( 211, 176, 131, 255 )
#define BROWN ColorRL( 127, 106, 79, 255 )
#define DARKBROWN ColorRL( 76, 63, 47, 255 )
#define WHITE ColorRL( 255, 255, 255, 255 )
#define BLACK ColorRL( 0, 0, 0, 255 )
#define BLANK ColorRL( 0, 0, 0, 0 )
#define MAGENTA ColorRL( 255, 0, 255, 255 )
#define RAYWHITE ColorRL( 245, 245, 245, 255 )

#ifndef Vector2
	Type Vector2
		x As Single
		y As Single
		Declare Constructor()
		Declare Constructor(x As Single, y As Single)
	End Type

	Constructor Vector2(x As Single, y As Single)
		This.x = x
		This.y = y
	End Constructor
	
	Constructor Vector2()
	End Constructor
#endif

#ifndef Vector3
	Type Vector3
		x As Single
		y As Single
		z As Single
		Declare Constructor()
		Declare Constructor(x As Single, y As Single, z As Single)
	End Type
	
	Constructor Vector3()
	End Constructor

	Constructor Vector3(x As Single, y As Single, z As Single)
		This.x = x
		This.y = y
	    This.z = z
	End Constructor
#endif

#ifndef Vector4
	Type Vector4
		x As Single
		y As Single
		z As Single
		w As Single
		Declare Constructor()
		Declare Constructor(x As Single, y As Single, z As Single, w As Single)
	End Type
	
	Constructor Vector4()
	End Constructor
	
	Constructor Vector4(x As Single, y As Single, z As Single, w As Single)
		This.x = x
		This.y = y
		This.z = z
		This.w = w
	End Constructor
#endif

#ifndef Quaternion
	Type Quaternion As Vector4
#endif

#ifndef Matrix
	Type Matrix
		m0 As Single
		m4 As Single
		m8 As Single
		m12 As Single
		m1 As Single
		m5 As Single
		m9 As Single
		m13 As Single
		m2 As Single
		m6 As Single
		m10 As Single
		m14 As Single
		m3 As Single
		m7 As Single
		m11 As Single
		m15 As Single
	End Type
#endif

Type ColorRL
	r As UByte
	g As UByte
	b As UByte
	a As UByte
	Declare Constructor()
	Declare Constructor(r As UByte, g As UByte, b As UByte, a As UByte)
End Type

Constructor ColorRL(r As UByte, g As UByte, b As UByte, a As UByte)
	This.r = r
	This.g = g
	This.b = b
	This.a = a
End Constructor

Constructor ColorRL()
End Constructor

Type Rectangle
	x As Single
	y As Single
	width As Single
	height As Single
	Declare Constructor()
	Declare Constructor(x As Single, y As Single, width_ As Single, height_ As Single)
End Type

Constructor Rectangle()
End Constructor

Constructor Rectangle(x As Single, y As Single, width_ As Single, height_ As Single)
	This.x = x
	This.y = y
	This.width = width_
	This.height = height_
End Constructor

Type Image
	data As Any Ptr
	width As Long
	height As Long
	mipmaps As Long
	format As Long
End Type

Type Texture
	id As ULong
	width As Long
	height As Long
	mipmaps As Long
	format As Long
End Type

Type Texture2D As Texture
Type TextureCubemap As Texture

Type RenderTexture
	id As ULong
	texture As Texture
	depth As Texture
End Type

Type RenderTexture2D As RenderTexture

Type NPatchInfo
	source As Rectangle
	left As Long
	top As Long
	right As Long
	bottom As Long
	layout As Long
End Type

Type GlyphInfo
	value As Long
	offsetX As Long
	offsetY As Long
	advanceX As Long
	image As Image
End Type

Type Font
	baseSize As Long
	glyphCount As Long
	glyphPadding As Long
	texture As Texture2D
	recs As Rectangle Ptr
	glyphs As GlyphInfo Ptr
End Type

Type Camera3D
	position As Vector3
	target As Vector3
	up As Vector3
	fovy As Single
	projection As Long
	Declare Constructor()
	Declare Constructor(position As Vector3, target As Vector3, up As Vector3, fovy As Single, projection As Long)
End Type

Constructor Camera3D() 
End Constructor 

Constructor Camera3D(position As Vector3, target As Vector3, up As Vector3, fovy As Single, projection As Long)
	This.position = position
	This.target = target
	This.up = up
	This.fovy = fovy
	This.projection = projection 
End Constructor  

Type Camera As Camera3D

Type Camera2D
	offset As Vector2
	target As Vector2
	rotation As Single
	zoom As Single
	Declare Constructor()
	Declare Constructor(offset As Vector2, target As Vector2, rototation As Single, zoom As Single)
End Type

Constructor Camera2D()
End Constructor

Constructor Camera2D(offset As Vector2, target As Vector2, rotation As Single, zoom As Single)
	This.offset = offset
	This.target = target
	This.rotation = rotation 
	This.zoom = zoom
End Constructor 

Type Mesh
	vertexCount As Long
	triangleCount As Long
	vertices As Single Ptr
	texcoords As Single Ptr
	texcoords2 As Single Ptr
	normals As Single Ptr
	tangents As Single Ptr
	colors As UByte Ptr
	indices As UShort Ptr
	animVertices As Single Ptr
	animNormals As Single Ptr
	boneIds As UByte Ptr
	boneWeights As Single Ptr
	vaoId As ULong
	vboId As ULong Ptr
End Type

Type Shader
	id As ULong
	locs As Long Ptr
End Type

Type MaterialMap
	texture As Texture2D
	color As ColorRL
	value As Single
End Type

Type Material
	shader As Shader
	maps As MaterialMap Ptr
	params(0 To 3) As Single
End Type

Type Transform
	translation As Vector3
	rotation As Quaternion
	scale As Vector3
End Type

Type BoneInfo
	name_ As ZString * 32
	parent As Long
End Type

Type Model
	transform As Matrix
	meshCount As Long
	materialCount As Long
	meshes As Mesh Ptr
	materials As Material Ptr
	meshMaterial As Long Ptr
	boneCount As Long
	bones As BoneInfo Ptr
	bindPose As Transform Ptr
End Type

Type ModelAnimation
	boneCount As Long
	frameCount As Long
	bones As BoneInfo Ptr
	framePoses As Transform Ptr Ptr
	name As ZString * 32
End Type

Type Ray
	position As Vector3
	direction As Vector3
End Type

Type RayCollision
	hit As Boolean
	distance As Single
	point_ As Vector3
	normal As Vector3
End Type

Type BoundingBox
	min As Vector3
	max As Vector3
End Type

Type Wave
	frameCount As ULong
	sampleRate As ULong
	sampleSize As ULong
	channels As ULong
	data_ As Any Ptr
End Type

Type rAudioBuffer As rAudioBuffer_
Type rAudioProcessor As rAudioProcessor_

Type AudioStream
	buffer As rAudioBuffer Ptr
	processor As rAudioProcessor Ptr
	sampleRate As ULong
	sampleSize As ULong
	channels As ULong
End Type

Type Sound
	stream As AudioStream
	frameCount As ULong
End Type

Type Music
	stream As AudioStream
	frameCount As ULong
	looping As Boolean
	ctxType As Long
	ctxData As Any Ptr
End Type

Type VrDeviceInfo
	hResolution As Long
	vResolution As Long
	hScreenSize As Single
	vScreenSize As Single
	eyeToScreenDistance As Single
	lensSeparationDistance As Single
	interpupillaryDistance As Single
	lensDistortionValues(0 To 3) As Single
	chromaAbCorrection(0 To 3) As Single
End Type

Type VrStereoConfig
	projection(0 To 1) As Matrix
	viewOffset(0 To 1) As Matrix
	leftLensCenter(0 To 1) As Single
	rightLensCenter(0 To 1) As Single
	leftScreenCenter(0 To 1) As Single
	rightScreenCenter(0 To 1) As Single
	scale(0 To 1) As Single
	scaleIn(0 To 1) As Single
End Type

Type FilePathList
	capacity As ULong
	count As ULong
	paths As ZString Ptr Ptr
End Type

Type AutomationEvent
	frame As ULong
	As ULong type
	params(0 To 3) As Long
End type

Type AutomationEventList
	capacity As ULong
	count As ULong
	events As AutomationEvent Ptr
End Type

Type ConfigFlags As Long
Enum
	FLAG_VSYNC_HINT = &h00000040
	FLAG_FULLSCREEN_MODE = &h00000002
	FLAG_WINDOW_RESIZABLE = &h00000004
	FLAG_WINDOW_UNDECORATED = &h00000008
	FLAG_WINDOW_HIDDEN = &h00000080
	FLAG_WINDOW_MINIMIZED = &h00000200
	FLAG_WINDOW_MAXIMIZED = &h00000400
	FLAG_WINDOW_UNFOCUSED = &h00000800
	FLAG_WINDOW_TOPMOST = &h00001000
	FLAG_WINDOW_ALWAYS_RUN = &h00000100
	FLAG_WINDOW_TRANSPARENT = &h00000010
	FLAG_WINDOW_HIGHDPI = &h00002000
	FLAG_WINDOW_MOUSE_PASSTHROUGH = &h00004000
	FLAG_BORDERLESS_WINDOWED_MODE = &h00008000
	FLAG_MSAA_4X_HINT = &h00000020
	FLAG_INTERLACED_HINT = &h00010000
End Enum

Enum TraceLogLevel
	LOG_ALL = 0
	LOG_TRACE
	LOG_DEBUG
	LOG_INFO
	LOG_WARNING
	LOG_ERROR
	LOG_FATAL
	LOG_NONE
End Enum

Enum KeyboardKey
	KEY_NULL = 0
	KEY_APOSTROPHE = 39
	KEY_COMMA = 44
	KEY_MINUS = 45
	KEY_PERIOD = 46
	KEY_SLASH = 47
	KEY_ZERO = 48
	KEY_ONE = 49
	KEY_TWO = 50
	KEY_THREE = 51
	KEY_FOUR = 52
	KEY_FIVE = 53
	KEY_SIX = 54
	KEY_SEVEN = 55
	KEY_EIGHT = 56
	KEY_NINE = 57
	KEY_SEMICOLON = 59
	KEY_EQUAL = 61
	KEY_A = 65
	KEY_B = 66
	KEY_C = 67
	KEY_D = 68
	KEY_E = 69
	KEY_F = 70
	KEY_G = 71
	KEY_H = 72
	KEY_I = 73
	KEY_J = 74
	KEY_K = 75
	KEY_L = 76
	KEY_M = 77
	KEY_N = 78
	KEY_O = 79
	KEY_P = 80
	KEY_Q = 81
	KEY_R = 82
	KEY_S = 83
	KEY_T = 84
	KEY_U = 85
	KEY_V = 86
	KEY_W = 87
	KEY_X = 88
	KEY_Y = 89
	KEY_Z = 90
	KEY_LEFT_BRACKET = 91
	KEY_BACKSLASH = 92
	KEY_RIGHT_BRACKET = 93
	KEY_GRAVE = 96
	KEY_SPACE = 32
	KEY_ESCAPE = 256
	KEY_ENTER = 257
	KEY_TAB = 258
	KEY_BACKSPACE = 259
	KEY_INSERT = 260
	KEY_DELETE = 261
	KEY_RIGHT = 262
	KEY_LEFT = 263
	KEY_DOWN = 264
	KEY_UP = 265
	KEY_PAGE_UP = 266
	KEY_PAGE_DOWN = 267
	KEY_HOME = 268
	KEY_END = 269
	KEY_CAPS_LOCK = 280
	KEY_SCROLL_LOCK = 281
	KEY_NUM_LOCK = 282
	KEY_PRINT_SCREEN = 283
	KEY_PAUSE = 284
	KEY_F1 = 290
	KEY_F2 = 291
	KEY_F3 = 292
	KEY_F4 = 293
	KEY_F5 = 294
	KEY_F6 = 295
	KEY_F7 = 296
	KEY_F8 = 297
	KEY_F9 = 298
	KEY_F10 = 299
	KEY_F11 = 300
	KEY_F12 = 301
	KEY_LEFT_SHIFT = 340
	KEY_LEFT_CONTROL = 341
	KEY_LEFT_ALT = 342
	KEY_LEFT_SUPER = 343
	KEY_RIGHT_SHIFT = 344
	KEY_RIGHT_CONTROL = 345
	KEY_RIGHT_ALT = 346
	KEY_RIGHT_SUPER = 347
	KEY_KB_MENU = 348
	KEY_KP_0 = 320
	KEY_KP_1 = 321
	KEY_KP_2 = 322
	KEY_KP_3 = 323
	KEY_KP_4 = 324
	KEY_KP_5 = 325
	KEY_KP_6 = 326
	KEY_KP_7 = 327
	KEY_KP_8 = 328
	KEY_KP_9 = 329
	KEY_KP_DECIMAL = 330
	KEY_KP_DIVIDE = 331
	KEY_KP_MULTIPLY = 332
	KEY_KP_SUBTRACT = 333
	KEY_KP_ADD = 334
	KEY_KP_ENTER = 335
	KEY_KP_EQUAL = 336
	KEY_BACK = 4
	KEY_MENU = 5
	KEY_VOLUME_UP = 24
	KEY_VOLUME_DOWN = 25
End Enum

Enum MouseButton
	MOUSE_BUTTON_LEFT = 0
	MOUSE_BUTTON_RIGHT = 1
	MOUSE_BUTTON_MIDDLE = 2
	MOUSE_BUTTON_SIDE = 3
	MOUSE_BUTTON_EXTRA = 4
	MOUSE_BUTTON_FORWARD = 5
	MOUSE_BUTTON_BACK = 6
End Enum

Const MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE
Const MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
Const MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT

Enum MouseCursor
	MOUSE_CURSOR_DEFAULT = 0
	MOUSE_CURSOR_ARROW = 1
	MOUSE_CURSOR_IBEAM = 2
	MOUSE_CURSOR_CROSSHAIR = 3
	MOUSE_CURSOR_POINTING_HAND = 4
	MOUSE_CURSOR_RESIZE_EW = 5
	MOUSE_CURSOR_RESIZE_NS = 6
	MOUSE_CURSOR_RESIZE_NWSE = 7
	MOUSE_CURSOR_RESIZE_NESW = 8
	MOUSE_CURSOR_RESIZE_ALL = 9
	MOUSE_CURSOR_NOT_ALLOWED = 10
End Enum

Enum GamepadButton
	GAMEPAD_BUTTON_UNKNOWN = 0
	GAMEPAD_BUTTON_LEFT_FACE_UP
	GAMEPAD_BUTTON_LEFT_FACE_RIGHT
	GAMEPAD_BUTTON_LEFT_FACE_DOWN
	GAMEPAD_BUTTON_LEFT_FACE_LEFT
	GAMEPAD_BUTTON_RIGHT_FACE_UP
	GAMEPAD_BUTTON_RIGHT_FACE_RIGHT
	GAMEPAD_BUTTON_RIGHT_FACE_DOWN
	GAMEPAD_BUTTON_RIGHT_FACE_LEFT
	GAMEPAD_BUTTON_LEFT_TRIGGER_1
	GAMEPAD_BUTTON_LEFT_TRIGGER_2
	GAMEPAD_BUTTON_RIGHT_TRIGGER_1
	GAMEPAD_BUTTON_RIGHT_TRIGGER_2
	GAMEPAD_BUTTON_MIDDLE_LEFT
	GAMEPAD_BUTTON_MIDDLE
	GAMEPAD_BUTTON_MIDDLE_RIGHT
	GAMEPAD_BUTTON_LEFT_THUMB
	GAMEPAD_BUTTON_RIGHT_THUMB
End Enum

Enum GamepadAxis
	GAMEPAD_AXIS_LEFT_X = 0
	GAMEPAD_AXIS_LEFT_Y = 1
	GAMEPAD_AXIS_RIGHT_X = 2
	GAMEPAD_AXIS_RIGHT_Y = 3
	GAMEPAD_AXIS_LEFT_TRIGGER = 4
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5
End Enum

Enum MaterialMapIndex
	MATERIAL_MAP_ALBEDO = 0
	MATERIAL_MAP_METALNESS
	MATERIAL_MAP_NORMAL
	MATERIAL_MAP_ROUGHNESS
	MATERIAL_MAP_OCCLUSION
	MATERIAL_MAP_EMISSION
	MATERIAL_MAP_HEIGHT
	MATERIAL_MAP_CUBEMAP
	MATERIAL_MAP_IRRADIANCE
	MATERIAL_MAP_PREFILTER
	MATERIAL_MAP_BRDF
End Enum

Const MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
Const MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

Enum ShaderLocationIndex
	SHADER_LOC_VERTEX_POSITION = 0
	SHADER_LOC_VERTEX_TEXCOORD01
	SHADER_LOC_VERTEX_TEXCOORD02
	SHADER_LOC_VERTEX_NORMAL
	SHADER_LOC_VERTEX_TANGENT
	SHADER_LOC_VERTEX_COLOR
	SHADER_LOC_MATRIX_MVP
	SHADER_LOC_MATRIX_VIEW
	SHADER_LOC_MATRIX_PROJECTION
	SHADER_LOC_MATRIX_MODEL
	SHADER_LOC_MATRIX_NORMAL
	SHADER_LOC_VECTOR_VIEW
	SHADER_LOC_COLOR_DIFFUSE
	SHADER_LOC_COLOR_SPECULAR
	SHADER_LOC_COLOR_AMBIENT
	SHADER_LOC_MAP_ALBEDO
	SHADER_LOC_MAP_METALNESS
	SHADER_LOC_MAP_NORMAL
	SHADER_LOC_MAP_ROUGHNESS
	SHADER_LOC_MAP_OCCLUSION
	SHADER_LOC_MAP_EMISSION
	SHADER_LOC_MAP_HEIGHT
	SHADER_LOC_MAP_CUBEMAP
	SHADER_LOC_MAP_IRRADIANCE
	SHADER_LOC_MAP_PREFILTER
	SHADER_LOC_MAP_BRDF
End Enum

Const SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
Const SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

Enum ShaderUniformDataType
	SHADER_UNIFORM_FLOAT = 0
	SHADER_UNIFORM_VEC2
	SHADER_UNIFORM_VEC3
	SHADER_UNIFORM_VEC4
	SHADER_UNIFORM_INT
	SHADER_UNIFORM_IVEC2
	SHADER_UNIFORM_IVEC3
	SHADER_UNIFORM_IVEC4
	SHADER_UNIFORM_SAMPLER2D
End Enum

Enum ShaderAttributeDataType
	SHADER_ATTRIB_FLOAT = 0
	SHADER_ATTRIB_VEC2
	SHADER_ATTRIB_VEC3
	SHADER_ATTRIB_VEC4
End Enum

Enum PixelFormat
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1
	PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA
	PIXELFORMAT_UNCOMPRESSED_R5G6B5
	PIXELFORMAT_UNCOMPRESSED_R8G8B8
	PIXELFORMAT_UNCOMPRESSED_R5G5B5A1
	PIXELFORMAT_UNCOMPRESSED_R4G4B4A4
	PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
	PIXELFORMAT_UNCOMPRESSED_R32
	PIXELFORMAT_UNCOMPRESSED_R32G32B32
	PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
	PIXELFORMAT_UNCOMPRESSED_R16
	PIXELFORMAT_UNCOMPRESSED_R16G16B16
	PIXELFORMAT_UNCOMPRESSED_R16G16B16A16
	PIXELFORMAT_COMPRESSED_DXT1_RGB
	PIXELFORMAT_COMPRESSED_DXT1_RGBA
	PIXELFORMAT_COMPRESSED_DXT3_RGBA
	PIXELFORMAT_COMPRESSED_DXT5_RGBA
	PIXELFORMAT_COMPRESSED_ETC1_RGB
	PIXELFORMAT_COMPRESSED_ETC2_RGB
	PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA
	PIXELFORMAT_COMPRESSED_PVRT_RGB
	PIXELFORMAT_COMPRESSED_PVRT_RGBA
	PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA
	PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA
End Enum

Enum TextureFilter
	TEXTURE_FILTER_POINT = 0
	TEXTURE_FILTER_BILINEAR
	TEXTURE_FILTER_TRILINEAR
	TEXTURE_FILTER_ANISOTROPIC_4X
	TEXTURE_FILTER_ANISOTROPIC_8X
	TEXTURE_FILTER_ANISOTROPIC_16X
End Enum

Enum TextureWrap
	TEXTURE_WRAP_REPEAT = 0
	TEXTURE_WRAP_CLAMP
	TEXTURE_WRAP_MIRROR_REPEAT
	TEXTURE_WRAP_MIRROR_CLAMP
End Enum

Enum CubemapLayout
	CUBEMAP_LAYOUT_AUTO_DETECT = 0
	CUBEMAP_LAYOUT_LINE_VERTICAL
	CUBEMAP_LAYOUT_LINE_HORIZONTAL
	CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR
	CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE
	CUBEMAP_LAYOUT_PANORAMA
End Enum

Enum FontType
	FONT_DEFAULT = 0
	FONT_BITMAP
	FONT_SDF
End Enum

Enum BlendMode
	BLEND_ALPHA = 0
	BLEND_ADDITIVE
	BLEND_MULTIPLIED
	BLEND_ADD_COLORS
	BLEND_SUBTRACT_COLORS
	BLEND_ALPHA_PREMULTIPLY
	BLEND_CUSTOM
  BLEND_CUSTOM_SEPARATE
End Enum

Enum Gesture
	GESTURE_NONE = 0
	GESTURE_TAP = 1
	GESTURE_DOUBLETAP = 2
	GESTURE_HOLD = 4
	GESTURE_DRAG = 8
	GESTURE_SWIPE_RIGHT = 16
	GESTURE_SWIPE_LEFT = 32
	GESTURE_SWIPE_UP = 64
	GESTURE_SWIPE_DOWN = 128
	GESTURE_PINCH_IN = 256
	GESTURE_PINCH_OUT = 512
End Enum

Enum CameraMode
	CAMERA_CUSTOM = 0
	CAMERA_FREE
	CAMERA_ORBITAL
	CAMERA_FIRST_PERSON
	CAMERA_THIRD_PERSON
End Enum

Enum CameraProjection
	CAMERA_PERSPECTIVE = 0
	CAMERA_ORTHOGRAPHIC
End Enum

Enum NPatchLayout
	NPATCH_NINE_PATCH = 0
	NPATCH_THREE_PATCH_VERTICAL
	NPATCH_THREE_PATCH_HORIZONTAL
End Enum

Type TraceLogCallback As Sub(ByVal logLevel As Long, ByVal text As Const ZString Ptr, ByVal args As va_list)
Type LoadFileDataCallback As Function(ByVal fileName As Const ZString Ptr, ByVal dataSize As Long Ptr) As UByte Ptr
Type SaveFileDataCallback As Function(ByVal fileName As Const ZString Ptr, ByVal Data As Any Ptr, ByVal dataSize As Long) As Boolean
Type LoadFileTextCallback As Function(ByVal fileName As Const ZString Ptr) As ZString Ptr
Type SaveFileTextCallback As Function(ByVal fileName As Const ZString Ptr, ByVal text As ZString Ptr) As Boolean

declare sub InitWindow(byval width as long, byval height as long, byval title as const zstring ptr)
Declare Sub CloseWindowRL()
Declare Sub CloseWindow()
Declare Function WindowShouldClose() As Boolean
Declare Function IsWindowReady() As Boolean
Declare Function IsWindowFullscreen() As Boolean
Declare Function IsWindowHidden() As Boolean
Declare Function IsWindowMinimized() As Boolean
Declare Function IsWindowMaximized() As Boolean
Declare Function IsWindowFocused() As Boolean
Declare Function IsWindowResized() As Boolean
Declare Function IsWindowState(ByVal flag As ULong) As Boolean
Declare Sub SetWindowState(ByVal flags As ULong)
Declare Sub ClearWindowState(ByVal flags As ULong)
Declare Sub ToggleFullscreen()
Declare Sub ToggleBorderlessWindowed()
Declare Sub MaximizeWindow()
Declare Sub MinimizeWindow()
Declare Sub RestoreWindow()
Declare Sub SetWindowIcon(ByVal image As Image)
Declare Sub SetWindowIcons(ByVal images As Image Ptr, ByVal count As Long)
Declare Sub SetWindowTitle(ByVal title As Const ZString Ptr)
Declare Sub SetWindowPosition(ByVal x As Long, ByVal y As Long)
Declare Sub SetWindowMonitor(ByVal monitor As Long)
Declare Sub SetWindowMinSize(ByVal width As Long, ByVal height As Long)
Declare Sub SetWindowMaxSize(ByVal width As Long, ByVal height As Long)
Declare Sub SetWindowSize(ByVal width As Long, ByVal height As Long)
Declare Sub SetWindowOpacity(ByVal opacity As Single)
Declare Sub SetWindowFocused()
Declare Function GetWindowHandle() As Any Ptr
Declare Function GetScreenWidth() As Long
Declare Function GetScreenHeight() As Long
Declare Function GetRenderWidth() As Long
Declare Function GetRenderHeight() As Long
Declare Function GetMonitorCount() As Long
Declare Function GetCurrentMonitor() As Long
Declare Function GetMonitorPosition(ByVal monitor As Long) As Vector2
Declare Function GetMonitorWidth(ByVal monitor As Long) As Long
Declare Function GetMonitorHeight(ByVal monitor As Long) As Long
Declare Function GetMonitorPhysicalWidth(ByVal monitor As Long) As Long
Declare Function GetMonitorPhysicalHeight(ByVal monitor As Long) As Long
Declare Function GetMonitorRefreshRate(ByVal monitor As Long) As Long
Declare Function GetWindowPosition() As Vector2
Declare Function GetWindowScaleDPI() As Vector2
Declare Function GetMonitorName(ByVal monitor As Long) As Const ZString Ptr
Declare Sub SetClipboardText(ByVal text As Const ZString Ptr)
Declare Function GetClipboardText() As Const ZString Ptr
Declare Sub EnableEventWaiting()
Declare Sub DisableEventWaiting()
Declare Sub ShowCursorRL()
Declare Sub ShowCursor()
Declare Sub HideCursor()
Declare Function IsCursorHidden() As Boolean
Declare Sub EnableCursor()
Declare Sub DisableCursor()
Declare Function IsCursorOnScreen() As Boolean
Declare Sub ClearBackground(ByVal Color As ColorRL)
Declare Sub BeginDrawing()
Declare Sub EndDrawing()
Declare Sub BeginMode2D(ByVal camera As Camera2D)
Declare Sub EndMode2D()
Declare Sub BeginMode3D(ByVal camera As Camera3D)
Declare Sub EndMode3D()
Declare Sub BeginTextureMode(ByVal target As RenderTexture2D)
Declare Sub EndTextureMode()
Declare Sub BeginShaderMode(ByVal shader As Shader)
Declare Sub EndShaderMode()
Declare Sub BeginBlendMode(ByVal mode As Long)
Declare Sub EndBlendMode()
Declare Sub BeginScissorMode(ByVal x As Long, ByVal y As Long, ByVal width_ As Long, ByVal height_ As Long)
Declare Sub EndScissorMode()
Declare Sub BeginVrStereoMode(ByRef config As VrStereoConfig)
Declare Sub EndVrStereoMode()
Declare Function LoadVrStereoConfig(ByVal device As VrDeviceInfo) As VrStereoConfig
Declare Sub UnloadVrStereoConfig(ByRef config As VrStereoConfig)
Declare Function LoadShader(ByVal vsFileName As Const ZString Ptr, ByVal fsFileName As Const ZString Ptr) As Shader
Declare Function LoadShaderFromMemory(ByVal vsCode As Const ZString Ptr, ByVal fsCode As Const ZString Ptr) As Shader
Declare Function IsShaderReady(ByVal shader As Shader) As Boolean
Declare Function GetShaderLocation(ByVal shader As Shader, ByVal uniformName As Const ZString Ptr) As Long
Declare Function GetShaderLocationAttrib(ByVal shader As Shader, ByVal attribName As Const ZString Ptr) As Long
Declare Sub SetShaderValue(ByVal shader As Shader, ByVal locIndex As Long, ByVal value As Const Any Ptr, ByVal uniformType As Long)
Declare Sub SetShaderValueV(ByVal shader As Shader, ByVal locIndex As Long, ByVal value As Const Any Ptr, ByVal uniformType As Long, ByVal count As Long)
Declare Sub SetShaderValueMatrix(ByVal shader As Shader, ByVal locIndex As Long, ByVal mat As Matrix)
Declare Sub SetShaderValueTexture(ByVal shader As Shader, ByVal locIndex As Long, ByVal texture As Texture2D)
Declare Sub UnloadShader(ByVal shader As Shader)
Declare Function GetMouseRay(ByVal mousePosition As Vector2, ByVal camera As Camera) As Ray
Declare Function GetCameraMatrix(ByVal camera As Camera) As Matrix
Declare Function GetCameraMatrix2D(ByVal camera As Camera2D) As Matrix
Declare Function GetWorldToScreen(ByVal position As Vector3, ByVal camera As Camera) As Vector2
Declare Function GetScreenToWorld2D(ByVal position As Vector2, ByVal camera As Camera2D) As Vector2
Declare Function GetWorldToScreenEx(ByVal position As Vector3, ByVal camera As Camera, ByVal width_ As Long, ByVal height_ As Long) As Vector2
Declare Function GetWorldToScreen2D(ByVal position As Vector2, ByVal camera As Camera2D) As Vector2
Declare Sub SetTargetFPS(ByVal fps As Long)
Declare Function GetFrameTime() As Single
Declare Function GetTime() As Double
Declare Function GetFPS() As Long
Declare Sub SwapScreenBuffer()
Declare Sub PollInputEvents()
Declare Sub WaitTime(ByVal seconds As Double)
Declare Sub SetRandomSeed(ByVal seed As ULong)
Declare Function GetRandomValue(ByVal min As Long, ByVal max As Long) As Long
Declare Function LoadRandomSequence(ByVal count As ULong, ByVal min As Long, ByVal max As Long) As Long Ptr
Declare Sub UnloadRandomSequence(ByVal sequence As Long Ptr)
Declare Sub TakeScreenshot(ByVal fileName As Const ZString Ptr)
Declare Sub SetConfigFlags(ByVal flags As ULong)
Declare Sub OpenURL(ByVal url As Const ZString Ptr)
Declare Sub TraceLog(ByVal logLevel As Long, ByVal text As Const ZString Ptr, ...)
Declare Sub SetTraceLogLevel(ByVal logLevel As Long)
Declare Function MemAlloc(ByVal size As ULong) As Any Ptr
Declare Function MemRealloc(ByVal ptr As Any ptr, ByVal size As ULong) As Any ptr
Declare Sub MemFree(ByVal ptr As Any ptr)
Declare Sub SetTraceLogCallback(ByVal callback As TraceLogCallback)
Declare Sub SetLoadFileDataCallback(ByVal callback As LoadFileDataCallback)
Declare Sub SetSaveFileDataCallback(ByVal callback As SaveFileDataCallback)
Declare Sub SetLoadFileTextCallback(ByVal callback As LoadFileTextCallback)
Declare Sub SetSaveFileTextCallback(ByVal callback As SaveFileTextCallback)
Declare Function LoadFileData(ByVal fileName As Const ZString Ptr, ByVal bytesRead As ULong Ptr) As UByte Ptr
Declare Sub UnloadFileData(ByVal data_ As UByte Ptr)
Declare Function SaveFileData(ByVal fileName As Const ZString Ptr, ByVal data_ As Any Ptr, ByVal bytesToWrite As ULong) As Boolean
Declare Function ExportDataAsCode(ByVal data_ As Const ZString Ptr, ByVal size As ULong, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function LoadFileText(ByVal fileName As Const ZString Ptr) As ZString Ptr
Declare Sub UnloadFileText(ByVal text As ZString Ptr)
Declare Function SaveFileText(ByVal fileName As Const ZString Ptr, ByVal text As ZString Ptr) As Boolean
Declare Function FileExists(ByVal fileName As Const ZString Ptr) As Boolean
Declare Function DirectoryExists(ByVal dirPath As Const ZString Ptr) As Boolean
Declare Function IsFileExtension(ByVal fileName As Const ZString Ptr, ByVal ext As Const ZString Ptr) As Boolean
Declare Function GetFileLength(ByVal fileName As Const ZString Ptr) As Long
Declare Function GetFileExtension(ByVal fileName As Const ZString Ptr) As Const ZString Ptr
Declare Function GetFileName(ByVal filePath As Const ZString Ptr) As Const ZString Ptr
Declare Function GetFileNameWithoutExt(ByVal filePath As Const ZString Ptr) As Const ZString Ptr
Declare Function GetDirectoryPath(ByVal filePath As Const ZString Ptr) As Const ZString Ptr
Declare Function GetPrevDirectoryPath(ByVal dirPath As Const ZString Ptr) As Const ZString Ptr
Declare Function GetWorkingDirectory() As Const ZString Ptr
Declare Function GetApplicationDirectory() As Const ZString Ptr
Declare Function ChangeDirectory(ByVal dir As Const ZString Ptr) As Boolean
Declare Function IsPathFile(ByVal path As Const ZString Ptr) As Boolean
Declare Function LoadDirectoryFiles(ByVal dirPath As Const ZString Ptr) As FilePathList
Declare Function LoadDirectoryFilesEx(ByVal basePath As Const ZString Ptr, ByVal filter As Const ZString Ptr, ByVal scanSubdirs As Boolean) As FilePathList
Declare Sub UnloadDirectoryFiles(ByVal files As FilePathList)
Declare Function IsFileDropped() As Boolean
Declare Function LoadDroppedFiles() As FilePathList
Declare Sub UnloadDroppedFiles(ByVal files As FilePathList)
Declare Function GetFileModTime(ByVal fileName As Const ZString Ptr) As clong
Declare Function CompressData(ByVal data_ As Const UByte Ptr, ByVal dataSize As Long, ByVal compDataSize As Long Ptr) As UByte Ptr
Declare Function DecompressData(ByVal compData As Const UByte Ptr, ByVal compDataSize As Long, ByVal dataSize As Long Ptr) As UByte Ptr
Declare Function EncodeDataBase64(ByVal data As Const UByte Ptr, ByVal dataSize As Long, ByVal outputSize As Long Ptr) As ZString Ptr
Declare Function DecodeDataBase64(ByVal data As Const UByte Ptr, ByVal outputSize As Long Ptr) As UByte Ptr
Declare Function LoadAutomationEventList(ByVal fileName As Const ZString Ptr) As AutomationEventList
Declare Sub UnloadAutomationEventList(ByVal list As AutomationEventList)
Declare Function ExportAutomationEventList(ByVal list As AutomationEventList, ByVal fileName As Const ZString Ptr) As Boolean
Declare Sub SetAutomationEventList(ByVal list As AutomationEventList Ptr)
Declare Sub SetAutomationEventBaseFrame(ByVal frame As Long)
Declare Sub StartAutomationEventRecording()
Declare Sub StopAutomationEventRecording()
Declare Sub PlayAutomationEvent(ByVal event As AutomationEvent)
Declare Function IsKeyPressed(ByVal key As Long) As Boolean
Declare Function IsKeyPressedRepeat(ByVal key As Long) As Boolean
Declare Function IsKeyDown(ByVal key As Long) As Boolean
Declare Function IsKeyReleased(ByVal key As Long) As Boolean
Declare Function IsKeyUp(ByVal key As Long) As Boolean
Declare Function GetKeyPressed() As Long
Declare Function GetCharPressed() As Long
Declare Sub SetExitKey(ByVal key As Long)
Declare Function IsGamepadAvailable(ByVal gamepad As Long) As Boolean
Declare Function GetGamepadName(ByVal gamepad As Long) As Const ZString Ptr
Declare Function IsGamepadButtonPressed(ByVal gamepad As Long, ByVal button As Long) As Boolean
Declare Function IsGamepadButtonDown(ByVal gamepad As Long, ByVal button As Long) As Boolean
Declare Function IsGamepadButtonReleased(ByVal gamepad As Long, ByVal button As Long) As Boolean
Declare Function IsGamepadButtonUp(ByVal gamepad As Long, ByVal button As Long) As Boolean
Declare Function GetGamepadButtonPressed() As Long
Declare Function GetGamepadAxisCount(ByVal gamepad As Long) As Long
Declare Function GetGamepadAxisMovement(ByVal gamepad As Long, ByVal axis As Long) As Single
Declare Function SetGamepadMappings(ByVal mappings As Const ZString Ptr) As Long
Declare Function IsMouseButtonPressed(ByVal button As Long) As Boolean
Declare Function IsMouseButtonDown(ByVal button As Long) As Boolean
Declare Function IsMouseButtonReleased(ByVal button As Long) As Boolean
Declare Function IsMouseButtonUp(ByVal button As Long) As Boolean
Declare Function GetMouseX() As Long
Declare Function GetMouseY() As Long
Declare Function GetMousePosition() As Vector2
Declare Function GetMouseDelta() As Vector2
Declare Sub SetMousePosition(ByVal x As Long, ByVal y As Long)
Declare Sub SetMouseOffset(ByVal offsetX As Long, ByVal offsetY As Long)
Declare Sub SetMouseScale(ByVal scaleX As Single, ByVal scaleY As Single)
Declare Function GetMouseWheelMove() As Single
Declare Function GetMouseWheelMoveV() As Vector2
Declare Sub SetMouseCursor(ByVal cursor As Long)
Declare Function GetTouchX() As Long
Declare Function GetTouchY() As Long
Declare Function GetTouchPosition(ByVal index As Long) As Vector2
Declare Function GetTouchPointId(ByVal index As Long) As Long
Declare Function GetTouchPointCount() As Long
Declare Sub SetGesturesEnabled(ByVal flags As ULong)
Declare Function IsGestureDetected(ByVal gesture As ULong) As Boolean
Declare Function GetGestureDetected() As Long
Declare Function GetGestureHoldDuration() As Single
Declare Function GetGestureDragVector() As Vector2
Declare Function GetGestureDragAngle() As Single
Declare Function GetGesturePinchVector() As Vector2
Declare Function GetGesturePinchAngle() As Single
Declare Sub UpdateCamera(ByVal camera As Camera Ptr, ByVal mode As Long)
Declare Sub UpdateCameraPro(ByVal camera As Camera Ptr, ByVal movement As Vector3, ByVal rotation As Vector3, ByVal zoom As Single)
Declare Sub SetShapesTexture(ByVal texture As Texture2D, ByVal source As Rectangle)
Declare Function GetShapesTexture() As Texture2D
Declare Function GetShapesTextureRectangle() As Rectangle
Declare Sub DrawPixel(ByVal posX As Long, ByVal posY As Long, ByVal Color As ColorRL)
Declare Sub DrawPixelV(ByVal position As Vector2, ByVal Color As ColorRL)
Declare Sub DrawLine(ByVal startPosX As Long, ByVal startPosY As Long, ByVal endPosX As Long, ByVal endPosY As Long, ByVal Color As ColorRL)
Declare Sub DrawLineV(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal Color As ColorRL)
Declare Sub DrawLineEx(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal thick As Single, ByVal Color As ColorRL)
declare sub DrawLineStrip(byval points as Vector2 ptr, byval pointCount as long, byval color as ColorRL)
declare sub DrawLineBezier(byval startPos as Vector2, byval endPos as Vector2, byval thick as single, byval color as ColorRL)
declare sub DrawCircle(byval centerX as long, byval centerY as long, byval radius as single, byval color as ColorRL)
declare sub DrawCircleSector(byval center as Vector2, byval radius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as ColorRL)
declare sub DrawCircleSectorLines(byval center as Vector2, byval radius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as ColorRL)
declare sub DrawCircleGradient(byval centerX as long, byval centerY as long, byval radius as single, byval color1 as ColorRL, byval color2 as ColorRL)
declare sub DrawCircleV(byval center as Vector2, byval radius as single, byval color as ColorRL)
declare sub DrawCircleLines(byval centerX as long, byval centerY as long, byval radius as single, byval color as ColorRL)
declare sub DrawCircleLinesV(byval center as Vector2, byval radius as single, byval color as ColorRL)
declare sub DrawEllipse(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval color as ColorRL)
declare sub DrawEllipseLines(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval color as ColorRL)
declare sub DrawRing(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as ColorRL)
declare sub DrawRingLines(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as ColorRL)
declare sub DrawRectangle(byval posX as long, byval posY as long, byval width as long, byval height as long, byval color as ColorRL)
declare sub DrawRectangleV(byval position as Vector2, byval size as Vector2, byval color as ColorRL)
declare sub DrawRectangleRec(byval rec as Rectangle, byval color as ColorRL)
declare sub DrawRectanglePro(byval rec as Rectangle, byval origin as Vector2, byval rotation as single, byval color as ColorRL)
declare sub DrawRectangleGradientV(byval posX as long, byval posY as long, byval width as long, byval height as long, byval color1 as ColorRL, byval color2 as ColorRL)
declare sub DrawRectangleGradientH(byval posX as long, byval posY as long, byval width as long, byval height as long, byval color1 as ColorRL, byval color2 as ColorRL)
declare sub DrawRectangleGradientEx(byval rec as Rectangle, byval col1 as ColorRL, byval col2 as ColorRL, byval col3 as ColorRL, byval col4 as ColorRL)
declare sub DrawRectangleLines(byval posX as long, byval posY as long, byval width as long, byval height as long, byval color as ColorRL)
declare sub DrawRectangleLinesEx(byval rec as Rectangle, byval lineThick as single, byval color as ColorRL)
declare sub DrawRectangleRounded(byval rec as Rectangle, byval roundness as single, byval segments as long, byval color as ColorRL)
declare sub DrawRectangleRoundedLines(byval rec as Rectangle, byval roundness as single, byval segments as long, byval lineThick as single, byval color as ColorRL)
declare sub DrawTriangle(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval color as ColorRL)
declare sub DrawTriangleLines(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval color as ColorRL)
declare sub DrawTriangleFan(byval points as Vector2 ptr, byval pointCount as long, byval color as ColorRL)
declare sub DrawTriangleStrip(byval points as Vector2 ptr, byval pointCount as long, byval color as ColorRL)
declare sub DrawPoly(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval color as ColorRL)
declare sub DrawPolyLines(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval color as ColorRL)
declare sub DrawPolyLinesEx(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval lineThick as single, byval color as ColorRL)
declare sub DrawSplineLinear(byval points as Vector2 ptr, byval pointCount as long, byval thick as single, byval color as ColorRL)
declare sub DrawSplineBasis(byval points as Vector2 ptr, byval pointCount as long, byval thick as single, byval color as ColorRL)
declare sub DrawSplineCatmullRom(byval points as Vector2 ptr, byval pointCount as long, byval thick as single, byval color as ColorRL)
declare sub DrawSplineBezierQuadratic(byval points as Vector2 ptr, byval pointCount as long, byval thick as single, byval color as ColorRL)
declare sub DrawSplineBezierCubic(byval points as Vector2 ptr, byval pointCount as long, byval thick as single, byval color as ColorRL)
declare sub DrawSplineSegmentLinear(byval p1 as Vector2, byval p2 as Vector2, byval thick as single, byval color as ColorRL)
declare sub DrawSplineSegmentBasis(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval thick as single, byval color as ColorRL)
declare sub DrawSplineSegmentCatmullRom(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval thick as single, byval color as ColorRL)
declare sub DrawSplineSegmentBezierQuadratic(byval p1 as Vector2, byval c2 as Vector2, byval p3 as Vector2, byval thick as single, byval color as ColorRL)
declare sub DrawSplineSegmentBezierCubic(byval p1 as Vector2, byval c2 as Vector2, byval c3 as Vector2, byval p4 as Vector2, byval thick as single, byval color as ColorRL)
declare function GetSplinePointLinear(byval startPos as Vector2, byval endPos as Vector2, byval t as single) as Vector2
declare function GetSplinePointBasis(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2
declare function GetSplinePointCatmullRom(byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2
declare function GetSplinePointBezierQuad(byval p1 as Vector2, byval c2 as Vector2, byval p3 as Vector2, byval t as single) as Vector2
declare function GetSplinePointBezierCubic(byval p1 as Vector2, byval c2 as Vector2, byval c3 as Vector2, byval p4 as Vector2, byval t as single) as Vector2
declare function CheckCollisionRecs(byval rec1 as Rectangle, byval rec2 as Rectangle) As Boolean
declare function CheckCollisionCircles(byval center1 as Vector2, byval radius1 as single, byval center2 as Vector2, byval radius2 as single) As Boolean
declare function CheckCollisionCircleRec(byval center as Vector2, byval radius as single, byval rec as Rectangle) As Boolean
Declare Function CheckCollisionPointRec(ByVal point As Vector2, ByVal rec As Rectangle) As Boolean
Declare Function CheckCollisionPointCircle(ByVal point As Vector2, ByVal center As Vector2, ByVal radius As Single) As Boolean
Declare Function CheckCollisionPointTriangle(ByVal point As Vector2, ByVal p1 As Vector2, ByVal p2 As Vector2, ByVal p3 As Vector2) As Boolean
Declare Function CheckCollisionPointPoly(ByVal point As Vector2, ByVal points As Vector2 Ptr, ByVal pointCount As Long) As Boolean
Declare Function CheckCollisionLines(ByVal startPos1 As Vector2, ByVal endPos1 As Vector2, ByVal startPos2 As Vector2, ByVal endPos2 As Vector2, ByVal collisionPoint As Vector2 Ptr) As Boolean
Declare Function CheckCollisionPointLine(ByVal point As Vector2, ByVal p1 As Vector2, ByVal p2 As Vector2, ByVal threshold As Long) As Boolean
Declare Function GetCollisionRec(ByVal rec1 As Rectangle, ByVal rec2 As Rectangle) As Rectangle
Declare Function LoadImage(ByVal fileName As Const ZString Ptr) As Image
Declare Function LoadImageRaw(ByVal fileName As Const ZString Ptr, ByVal width As Long, ByVal height As Long, ByVal format As Long, ByVal headerSize As Long) As Image
Declare Function LoadImageSvg(ByVal fileNameOrString As Const ZString Ptr, ByVal width As Long, ByVal height As Long) As Image
Declare Function LoadImageAnim(ByVal fileName As Const ZString Ptr, ByVal frames As Long Ptr) As Image
Declare Function LoadImageAnimFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long, ByVal frames As Long Ptr) As Image
Declare Function LoadImageFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long) As Image
Declare Function LoadImageFromTexture(ByVal texture As Texture2D) As Image
Declare Function LoadImageFromScreen() As Image
Declare Function IsImageReady(ByVal image As Image) As Boolean
Declare Sub UnloadImage(ByVal image As Image)
Declare Function ExportImage(ByVal image As Image, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function ExportImageToMemory(ByVal image As Image, ByVal fileType As Const ZString Ptr, ByVal fileSize As Long Ptr) As UByte Ptr
Declare Function ExportImageAsCode(ByVal image As Image, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function GenImageColor(ByVal width As Long, ByVal height As Long, ByVal color As ColorRL) As Image
Declare Function GenImageGradientLinear(ByVal width As Long, ByVal height As Long, ByVal direction As Long, ByVal start As ColorRL, ByVal end As ColorRL) As Image
Declare Function GenImageGradientRadial(ByVal width As Long, ByVal height As Long, ByVal density As Single, ByVal inner As ColorRL, ByVal outer As ColorRL) As Image
Declare Function GenImageGradientSquare(ByVal width As Long, ByVal height As Long, ByVal density As Single, ByVal inner As ColorRL, ByVal outer As ColorRL) As Image
Declare Function GenImageChecked(ByVal width As Long, ByVal height As Long, ByVal checksX As Long, ByVal checksY As Long, ByVal col1 As ColorRL, ByVal col2 As ColorRL) As Image
Declare Function GenImageWhiteNoise(ByVal width As Long, ByVal height As Long, ByVal factor As Single) As Image
Declare Function GenImagePerlinNoise(ByVal width As Long, ByVal height As Long, ByVal offsetX As Long, ByVal offsetY As Long, ByVal scale As Single) As Image
Declare Function GenImageCellular(ByVal width As Long, ByVal height As Long, ByVal tileSize As Long) As Image
Declare Function GenImageText(ByVal width As Long, ByVal height As Long, ByVal text As Const ZString Ptr) As Image
declare function ImageCopy(byval image as Image) as Image
declare function ImageFromImage(byval image as Image, byval rec as Rectangle) as Image
declare function ImageText(byval text as const zstring ptr, byval fontSize as long, byval color as ColorRL) as Image
declare function ImageTextEx(byval font as Font, byval text as const zstring ptr, byval fontSize as single, byval spacing as single, byval tint as ColorRL) as Image
declare sub ImageFormat(byval image as Image ptr, byval newFormat as long)
declare sub ImageToPOT(byval image as Image ptr, byval fill as ColorRL)
declare sub ImageCrop(byval image as Image ptr, byval crop as Rectangle)
declare sub ImageAlphaCrop(byval image as Image ptr, byval threshold as single)
declare sub ImageAlphaClear(byval image as Image ptr, byval color as ColorRL, byval threshold as single)
declare sub ImageAlphaMask(byval image as Image ptr, byval alphaMask as Image)
declare sub ImageAlphaPremultiply(byval image as Image ptr)
declare sub ImageBlurGaussian(byval image as Image ptr, byval blurSize as long)
declare sub ImageKernelConvolution(byval image as Image ptr, byval kernel as single ptr, byval kernelSize as long)
declare sub ImageResize(byval image as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeNN(byval image as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeCanvas(byval image as Image ptr, byval newWidth as long, byval newHeight as long, byval offsetX as long, byval offsetY as long, byval fill as ColorRL)
declare sub ImageMipmaps(byval image as Image ptr)
declare sub ImageDither(byval image as Image ptr, byval rBpp as long, byval gBpp as long, byval bBpp as long, byval aBpp as long)
declare sub ImageFlipVertical(byval image as Image ptr)
declare sub ImageFlipHorizontal(byval image as Image ptr)
declare sub ImageRotate(byval image as Image ptr, byval degrees as long)
declare sub ImageRotateCW(byval image as Image ptr)
declare sub ImageRotateCCW(byval image as Image ptr)
declare sub ImageColorTint(byval image as Image ptr, byval color as ColorRL)
declare sub ImageColorInvert(byval image as Image ptr)
declare sub ImageColorGrayscale(byval image as Image ptr)
declare sub ImageColorContrast(byval image as Image ptr, byval contrast as single)
declare sub ImageColorBrightness(byval image as Image ptr, byval brightness as long)
declare sub ImageColorReplace(byval image as Image ptr, byval color as ColorRL, byval replace as ColorRL)
declare function LoadImageColors(byval image as Image) as ColorRL ptr
declare function LoadImagePalette(byval image as Image, byval maxPaletteSize as long, byval colorCount as long ptr) as ColorRL ptr
declare sub UnloadImageColors(byval colors as ColorRL ptr)
declare sub UnloadImagePalette(byval colors as ColorRL ptr)
declare function GetImageAlphaBorder(byval image as Image, byval threshold as single) as Rectangle
declare function GetImageColor(byval image as Image, byval x as long, byval y as long) as ColorRL
declare sub ImageClearBackground(byval dst as Image ptr, byval color as ColorRL)
declare sub ImageDrawPixel(byval dst as Image ptr, byval posX as long, byval posY as long, byval color as ColorRL)
declare sub ImageDrawPixelV(byval dst as Image ptr, byval position as Vector2, byval color as ColorRL)
Declare Sub ImageDrawLine(ByVal dst As Image Ptr, ByVal startPosX As Long, ByVal startPosY As Long, ByVal endPosX As Long, ByVal endPosY As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawLineV(ByVal dst As Image Ptr, ByVal start As Vector2, ByVal End As Vector2, ByVal Color As ColorRL)
Declare Sub ImageDrawCircle(ByVal dst As Image Ptr, ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawCircleV(ByVal dst As Image Ptr, ByVal center As Vector2, ByVal radius As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawCircleLines(ByVal dst As Image Ptr, ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawCircleLinesV(ByVal dst As Image Ptr, ByVal center As Vector2, ByVal radius As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawRectangle(ByVal dst As Image Ptr, ByVal posX As Long, ByVal posY As Long, ByVal Width As Long, ByVal height As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawRectangleV(ByVal dst As Image Ptr, ByVal position As Vector2, ByVal size As Vector2, ByVal Color As ColorRL)
Declare Sub ImageDrawRectangleRec(ByVal dst As Image Ptr, ByVal rec As Rectangle, ByVal Color As ColorRL)
Declare Sub ImageDrawRectangleLines(ByVal dst As Image Ptr, ByVal rec As Rectangle, ByVal thick As Long, ByVal Color As ColorRL)
Declare Sub ImageDraw(ByVal dst As Image Ptr, ByVal src As Image, ByVal srcRec As Rectangle, ByVal dstRec As Rectangle, ByVal tint As ColorRL)
Declare Sub ImageDrawText(ByVal dst As Image Ptr, ByVal text As Const ZString Ptr, ByVal posX As Long, ByVal posY As Long, ByVal fontSize As Long, ByVal Color As ColorRL)
Declare Sub ImageDrawTextEx(ByVal dst As Image Ptr, ByVal Font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As ColorRL)
Declare Function LoadTexture(ByVal fileName As Const ZString Ptr) As Texture2D
Declare Function LoadTextureFromImage(ByVal image As Image) As Texture2D
Declare Function LoadTextureCubemap(ByVal image As Image, ByVal layout As Long) As TextureCubemap
Declare Function LoadRenderTexture(ByVal width As Long, ByVal height As Long) As RenderTexture2D
Declare Function IsTextureReady(ByVal texture As Texture2D) As Boolean
Declare Sub UnloadTexture(ByVal texture As Texture2D)
Declare Function IsRenderTextureReady(ByVal target As RenderTexture2D) As Boolean
Declare Sub UnloadRenderTexture(ByVal target As RenderTexture2D)
Declare Sub UpdateTexture(ByVal texture As Texture2D, ByVal pixels As Const Any Ptr)
Declare Sub UpdateTextureRec(ByVal texture As Texture2D, ByVal rec As Rectangle, ByVal pixels As Const Any Ptr)
Declare Sub GenTextureMipmaps(ByVal texture As Texture2D Ptr)
Declare Sub SetTextureFilter(ByVal texture As Texture2D, ByVal filter As Long)
Declare Sub SetTextureWrap(ByVal texture As Texture2D, ByVal wrap As Long)
Declare Sub DrawTexture(ByVal Texture As Texture2D, ByVal posX As Long, ByVal posY As Long, ByVal tint As ColorRL)
Declare Sub DrawTextureV(ByVal Texture As Texture2D, ByVal position As Vector2, ByVal tint As ColorRL)
Declare Sub DrawTextureEx(ByVal Texture As Texture2D, ByVal position As Vector2, ByVal rotation As Single, ByVal scale As Single, ByVal tint As ColorRL)
declare sub DrawTextureRec(byval texture as Texture2D, byval source as Rectangle, byval position as Vector2, byval tint as ColorRL)
declare sub DrawTexturePro(byval texture as Texture2D, byval source as Rectangle, byval dest as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as ColorRL)
declare sub DrawTextureNPatch(byval texture as Texture2D, byval nPatchInfo as NPatchInfo, byval dest as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as ColorRL)
declare function Fade(byval color as ColorRL, byval alpha as single) as ColorRL
declare function ColorToInt(byval color as ColorRL) as long
declare function ColorNormalize(byval color as ColorRL) as Vector4
declare function ColorFromNormalized(byval normalized as Vector4) as ColorRL
declare function ColorToHSV(byval color as ColorRL) as Vector3
Declare Function ColorFromHSV(ByVal hue As Single, ByVal saturation As Single, ByVal value As Single) As ColorRL
Declare Function ColorTint(ByVal color As ColorRL, ByVal tint As ColorRL) As ColorRL
Declare Function ColorBrightness(ByVal color As ColorRL, ByVal factor As Single) As ColorRL
Declare Function ColorContrast(ByVal color As ColorRL, ByVal contrast As Single) As ColorRL
Declare Function ColorAlpha(ByVal color As ColorRL, ByVal alpha As Single) As ColorRL
Declare Function ColorAlphaBlend(ByVal dst As ColorRL, ByVal src As ColorRL, ByVal tint As ColorRL) As ColorRL
Declare Function GetColor(ByVal hexValue As ULong) As ColorRL
Declare Function GetPixelColor(ByVal srcPtr As Any Ptr, ByVal format As Long) As ColorRL
Declare Sub SetPixelColor(ByVal dstPtr As Any Ptr, ByVal Color As ColorRL, ByVal Format As Long)
Declare Function GetPixelDataSize(ByVal width As Long, ByVal height As Long, ByVal format As Long) As Long
Declare Function GetFontDefault() As Font
Declare Function LoadFont(ByVal fileName As Const ZString Ptr) As Font
Declare Function LoadFontEx(ByVal fileName As Const ZString Ptr, ByVal fontSize As Long, ByVal codepoints As Long Ptr, ByVal codepointCount As Long) As Font
Declare Function LoadFontFromImage(ByVal image As Image, ByVal key As ColorRL, ByVal firstChar As Long) As Font
Declare Function LoadFontFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long, ByVal fontSize As Long, ByVal codepoints As Long Ptr, ByVal codepointCount As Long) As Font
Declare Function IsFontReady(ByVal font As Font) As Boolean
Declare Function LoadFontData(ByVal fileData As Const UByte Ptr, ByVal dataSize As Long, ByVal fontSize As Long, ByVal codepoints As Long Ptr, ByVal codepointCount As Long, ByVal type As Long) As GlyphInfo Ptr
Declare Function GenImageFontAtlas(ByVal glyphs As Const GlyphInfo Ptr, ByVal glyphRecs As Rectangle Ptr Ptr, ByVal glyphCount As Long, ByVal fontSize As Long, ByVal padding As Long, ByVal packMethod As Long) As Image
Declare Sub UnloadFontData(ByVal glyphs As GlyphInfo Ptr, ByVal glyphCount As Long)
Declare Sub UnloadFont(ByVal font As Font)
Declare Function ExportFontAsCode(ByVal font As Font, ByVal fileName As Const ZString Ptr) As Boolean
Declare Sub DrawFPS(ByVal posX As Long, ByVal posY As Long)
Declare Sub DrawText(ByVal text As Const ZString Ptr, ByVal posX As Long, ByVal posY As Long, ByVal fontSize As Long, ByVal Color As ColorRL)
Declare Sub DrawTextEx(ByVal Font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As ColorRL)
Declare Sub DrawTextPro(ByVal Font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal origin As Vector2, ByVal rotation As Single, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As ColorRL)
Declare Sub DrawTextCodepoint(ByVal Font As Font, ByVal codepoint As Long, ByVal position As Vector2, ByVal fontSize As Single, ByVal tint As ColorRL)
Declare Sub DrawTextCodepoints(ByVal Font As Font, ByVal codepoints As Const Long Ptr, ByVal codepointCount As Long, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As ColorRL)
Declare Sub SetTextLineSpacing(ByVal spacing As Long)
Declare Function MeasureText(ByVal text As Const ZString Ptr, ByVal fontSize As Long) As Long
Declare Function MeasureTextEx(ByVal font As Font, ByVal text As Const ZString Ptr, ByVal fontSize As Single, ByVal spacing As Single) As Vector2
Declare Function GetGlyphIndex(ByVal font As Font, ByVal codepoint As Long) As Long
Declare Function GetGlyphInfo(ByVal font As Font, ByVal codepoint As Long) As GlyphInfo
Declare Function GetGlyphAtlasRec(ByVal font As Font, ByVal codepoint As Long) As Rectangle
Declare Function LoadUTF8(ByVal codepoints As Const Long Ptr, ByVal length As Long) As ZString Ptr
Declare Sub UnloadUTF8(ByVal text As ZString Ptr)
Declare Function LoadCodepoints(ByVal text As Const ZString Ptr, ByVal count As Long Ptr) As Long Ptr
Declare Sub UnloadCodepoints(ByVal codepoints As Long Ptr)
Declare Function GetCodepointCount(ByVal text As Const ZString Ptr) As Long
Declare Function GetCodepoint(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function GetCodepointNext(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function GetCodepointPrevious(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function CodepointToUTF8(ByVal codepoint As Long, ByVal utf8Size As Long Ptr) As Const ZString Ptr
Declare Function TextCopy(ByVal dst As ZString Ptr, ByVal src As Const ZString Ptr) As Long
Declare Function TextIsEqual(ByVal text1 As Const ZString Ptr, ByVal text2 As Const ZString Ptr) As Boolean
Declare Function TextLength(ByVal text As Const ZString Ptr) As ULong
Declare Function TextFormat(ByVal text As Const ZString Ptr, ...) As Const ZString Ptr
Declare Function TextSubtext(ByVal text As Const ZString Ptr, ByVal position As Long, ByVal length As Long) As Const ZString Ptr
Declare Function TextReplace(ByVal text As Const ZString Ptr, ByVal replace As Const ZString Ptr, ByVal by As Const ZString Ptr) As ZString Ptr
Declare Function TextInsert(ByVal text As Const ZString Ptr, ByVal insert As Const ZString Ptr, ByVal position As Long) As ZString Ptr
Declare Function TextJoin(ByVal textList As Const ZString Ptr Ptr, ByVal count As Long, ByVal delimiter As Const ZString Ptr) As Const ZString Ptr
Declare Function TextSplit(ByVal text As Const ZString Ptr, ByVal delimiter As Byte, ByVal count As Long Ptr) As Const ZString Ptr Ptr
Declare Sub TextAppend(ByVal text As ZString Ptr, ByVal append As Const ZString Ptr, ByVal position As Long Ptr)
Declare Function TextFindIndex(ByVal text As Const ZString Ptr, ByVal find As Const ZString Ptr) As Long
Declare Function TextToUpper(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToLower(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToPascal(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToInteger(ByVal text As Const ZString Ptr) As Long
Declare Function TextToFloat(ByVal text As Const ZString Ptr) As Single
Declare Sub DrawLine3D(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal Color As ColorRL)
Declare Sub DrawPoint3D(ByVal position As Vector3, ByVal Color As ColorRL)
Declare Sub DrawCircle3D(ByVal center As Vector3, ByVal radius As Single, ByVal rotationAxis As Vector3, ByVal rotationAngle As Single, ByVal Color As ColorRL)
Declare Sub DrawTriangle3D(ByVal v1 As Vector3, ByVal v2 As Vector3, ByVal v3 As Vector3, ByVal Color As ColorRL)
Declare Sub DrawTriangleStrip3D(ByVal points As Vector3 Ptr, ByVal pointCount As Long, ByVal Color As ColorRL)
Declare Sub DrawCube(ByVal position As Vector3, ByVal Width As Single, ByVal height As Single, ByVal length As Single, ByVal Color As ColorRL)
Declare Sub DrawCubeV(ByVal position As Vector3, ByVal size As Vector3, ByVal Color As ColorRL)
Declare Sub DrawCubeWires(ByVal position As Vector3, ByVal Width As Single, ByVal height As Single, ByVal length As Single, ByVal Color As ColorRL)
Declare Sub DrawCubeWiresV(ByVal position As Vector3, ByVal size As Vector3, ByVal Color As ColorRL)
Declare Sub DrawSphere(ByVal centerPos As Vector3, ByVal radius As Single, ByVal Color As ColorRL)
Declare Sub DrawSphereEx(ByVal centerPos As Vector3, ByVal radius As Single, ByVal rings As Long, ByVal slices As Long, ByVal Color As ColorRL)
Declare Sub DrawSphereWires(ByVal centerPos As Vector3, ByVal radius As Single, ByVal rings As Long, ByVal slices As Long, ByVal Color As ColorRL)
Declare Sub DrawCylinder(ByVal position As Vector3, ByVal radiusTop As Single, ByVal radiusBottom As Single, ByVal height As Single, ByVal slices As Long, ByVal Color As ColorRL)
declare sub DrawCylinderEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval color as ColorRL)
declare sub DrawCylinderWires(byval position as Vector3, byval radiusTop as single, byval radiusBottom as single, byval height as single, byval slices as long, byval color as ColorRL)
declare sub DrawCylinderWiresEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval color as ColorRL)
declare sub DrawCapsule(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval color as ColorRL)
declare sub DrawCapsuleWires(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval color as ColorRL)
declare sub DrawPlane(byval centerPos as Vector3, byval size as Vector2, byval color as ColorRL)
declare sub DrawRay(byval ray as Ray, byval color as ColorRL)
Declare Sub DrawGrid(ByVal slices As Long, ByVal spacing As Single)
Declare Function LoadModel(ByVal fileName As Const ZString Ptr) As Model
Declare Function LoadModelFromMesh(ByVal mesh As Mesh) As Model
declare function IsModelReady(byval model as Model) As Boolean
Declare Sub UnloadModel(ByVal model As Model)
Declare Function GetModelBoundingBox(ByVal model As Model) As BoundingBox
declare sub DrawModel(byval model as Model, byval position as Vector3, byval scale as single, byval tint as ColorRL)
declare sub DrawModelEx(byval model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as ColorRL)
Declare Sub DrawModelWires(ByVal Model As Model, ByVal position As Vector3, ByVal scale As Single, ByVal tint As ColorRL)
Declare Sub DrawModelWiresEx(ByVal Model As Model, ByVal position As Vector3, ByVal rotationAxis As Vector3, ByVal rotationAngle As Single, ByVal scale As Vector3, ByVal tint As ColorRL)
Declare Sub DrawBoundingBox(ByVal box As BoundingBox, ByVal Color As ColorRL)
Declare Sub DrawBillboard(ByVal Camera As Camera, ByVal Texture As Texture2D, ByVal position As Vector3, ByVal size As Single, ByVal tint As ColorRL)
Declare Sub DrawBillboardRec(ByVal Camera As Camera, ByVal Texture As Texture2D, ByVal source As Rectangle, ByVal position As Vector3, ByVal size As Vector2, ByVal tint As ColorRL)
Declare Sub DrawBillboardPro(ByVal Camera As Camera, ByVal Texture As Texture2D, ByVal source As Rectangle, ByVal position As Vector3, ByVal up As Vector3, ByVal size As Vector2, ByVal origin As Vector2, ByVal rotation As Single, ByVal tint As ColorRL)
Declare Sub UploadMesh(ByVal mesh As Mesh Ptr, ByVal dynamic As Boolean)
Declare Sub UpdateMeshBuffer(ByVal mesh As Mesh, ByVal index As Long, ByVal data As Const Any Ptr, ByVal dataSize As Long, ByVal offset As Long)
Declare Sub UnloadMesh(ByVal mesh As Mesh)
Declare Sub DrawMesh(ByVal mesh As Mesh, ByVal material As Material, ByVal transform As Matrix)
Declare Sub DrawMeshInstanced(ByVal mesh As Mesh, ByVal material As Material, ByVal transforms As Const Matrix Ptr, ByVal instances As Long)
Declare Function GetMeshBoundingBox(ByVal mesh As Mesh) As BoundingBox
Declare Sub GenMeshTangents(ByVal mesh As Mesh Ptr)
Declare Function ExportMesh(ByVal mesh As Mesh, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function ExportMeshAsCode(ByVal mesh As Mesh, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function GenMeshPoly(ByVal sides As Long, ByVal radius As Single) As Mesh
Declare Function GenMeshPlane(ByVal width As Single, ByVal length As Single, ByVal resX As Long, ByVal resZ As Long) As Mesh
Declare Function GenMeshCube(ByVal width As Single, ByVal height As Single, ByVal length As Single) As Mesh
Declare Function GenMeshSphere(ByVal radius As Single, ByVal rings As Long, ByVal slices As Long) As Mesh
Declare Function GenMeshHemiSphere(ByVal radius As Single, ByVal rings As Long, ByVal slices As Long) As Mesh
Declare Function GenMeshCylinder(ByVal radius As Single, ByVal height As Single, ByVal slices As Long) As Mesh
Declare Function GenMeshCone(ByVal radius As Single, ByVal height As Single, ByVal slices As Long) As Mesh
Declare Function GenMeshTorus(ByVal radius As Single, ByVal size As Single, ByVal radSeg As Long, ByVal sides As Long) As Mesh
Declare Function GenMeshKnot(ByVal radius As Single, ByVal size As Single, ByVal radSeg As Long, ByVal sides As Long) As Mesh
Declare Function GenMeshHeightmap(ByVal heightmap As Image, ByVal size As Vector3) As Mesh
Declare Function GenMeshCubicmap(ByVal cubicmap As Image, ByVal cubeSize As Vector3) As Mesh
Declare Function LoadMaterials(ByVal fileName As Const ZString Ptr, ByVal materialCount As Long Ptr) As Material Ptr
Declare Function LoadMaterialDefault() As Material
Declare Function IsMaterialReady(ByVal material As Material) As Boolean
Declare Sub UnloadMaterial(ByVal material As Material)
Declare Sub SetMaterialTexture(ByVal material As Material Ptr, ByVal mapType As Long, ByVal texture As Texture2D)
Declare Sub SetModelMeshMaterial(ByVal model As Model Ptr, ByVal meshId As Long, ByVal materialId As Long)
Declare Function LoadModelAnimations(ByVal fileName As Const ZString Ptr, ByVal animCount As Long Ptr) As ModelAnimation Ptr
Declare Sub UpdateModelAnimation(ByVal model As Model, ByVal anim As ModelAnimation, ByVal frame As Long)
Declare Sub UnloadModelAnimation(ByVal anim As ModelAnimation)
Declare Sub UnloadModelAnimations(ByVal animations As ModelAnimation Ptr, ByVal animCount As Long)
Declare Function IsModelAnimationValid(ByVal model As Model, ByVal anim As ModelAnimation) As Boolean
Declare Function CheckCollisionSpheres(ByVal center1 As Vector3, ByVal radius1 As Single, ByVal center2 As Vector3, ByVal radius2 As Single) As Boolean
Declare Function CheckCollisionBoxes(ByVal box1 As BoundingBox, ByVal box2 As BoundingBox) As Boolean
Declare Function CheckCollisionBoxSphere(ByVal box As BoundingBox, ByVal center As Vector3, ByVal radius As Single) As Boolean
Declare Function GetRayCollisionSphere(ByVal ray As Ray, ByVal center As Vector3, ByVal radius As Single) As RayCollision
Declare Function GetRayCollisionBox(ByVal ray As Ray, ByVal box As BoundingBox) As RayCollision
Declare Function GetRayCollisionMesh(ByVal ray As Ray, ByVal mesh As Mesh, ByVal transform As Matrix) As RayCollision
Declare Function GetRayCollisionTriangle(ByVal ray As Ray, ByVal p1 As Vector3, ByVal p2 As Vector3, ByVal p3 As Vector3) As RayCollision
Declare Function GetRayCollisionQuad(ByVal ray As Ray, ByVal p1 As Vector3, ByVal p2 As Vector3, ByVal p3 As Vector3, ByVal p4 As Vector3) As RayCollision
Type AudioCallback As Sub(ByVal bufferData As Any Ptr, ByVal frames As ULong)
Declare Sub InitAudioDevice()
Declare Sub CloseAudioDevice()
Declare Function IsAudioDeviceReady() As Boolean
Declare Sub SetMasterVolume(ByVal volume As Single)
Declare Function GetMasterVolume() As Single
Declare Function LoadWave(ByVal fileName As Const ZString Ptr) As Wave
Declare Function LoadWaveFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long) As Wave
Declare Function IsWaveReady(ByVal wave As Wave) As Boolean
Declare Function LoadSound(ByVal fileName As Const ZString Ptr) As Sound
Declare Function LoadSoundFromWave(ByVal wave As Wave) As Sound
Declare Function LoadSoundAlias(ByVal source As Sound) As Sound
Declare Function IsSoundReady(ByVal sound As Sound) As Boolean
Declare Sub UpdateSound(ByVal sound As Sound, ByVal data As Const Any Ptr, ByVal sampleCount As Long)
Declare Sub UnloadWave(ByVal wave As Wave)
Declare Sub UnloadSound(ByVal sound As Sound)
Declare Sub UnloadSoundAlias(ByVal alias As Sound)
Declare Function ExportWave(ByVal wave As Wave, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function ExportWaveAsCode(ByVal wave As Wave, ByVal fileName As Const ZString Ptr) As Boolean
Declare Sub PlaySoundRL(ByVal sound As Sound)
Declare Sub PlaySound(ByVal sound As Sound)
Declare Sub StopSound(ByVal sound As Sound)
Declare Sub PauseSound(ByVal sound As Sound)
Declare Sub ResumeSound(ByVal sound As Sound)
Declare Function IsSoundPlaying(ByVal sound As Sound) As Boolean
Declare Sub SetSoundVolume(ByVal sound As Sound, ByVal volume As Single)
Declare Sub SetSoundPitch(ByVal sound As Sound, ByVal pitch As Single)
Declare Sub SetSoundPan(ByVal sound As Sound, ByVal pan As Single)
Declare Function WaveCopy(ByVal wave As Wave) As Wave
Declare Sub WaveCrop(ByVal wave As Wave Ptr, ByVal initSample As Long, ByVal finalSample As Long)
Declare Sub WaveFormat(ByVal wave As Wave Ptr, ByVal sampleRate As Long, ByVal sampleSize As Long, ByVal channels As Long)
Declare Function LoadWaveSamples(ByVal wave As Wave) As Single Ptr
Declare Sub UnloadWaveSamples(ByVal samples As Single Ptr)
Declare Function LoadMusicStream(ByVal fileName As Const ZString Ptr) As Music
Declare Function LoadMusicStreamFromMemory(ByVal fileType As Const ZString Ptr, ByVal data As Const UByte Ptr, ByVal dataSize As Long) As Music
Declare Function IsMusicReady(ByVal music As Music) As Boolean
Declare Sub UnloadMusicStream(ByVal music As Music)
Declare Sub PlayMusicStream(ByVal music As Music)
Declare Function IsMusicStreamPlaying(ByVal music As Music) As Boolean
Declare Sub UpdateMusicStream(ByVal music As Music)
Declare Sub StopMusicStream(ByVal music As Music)
Declare Sub PauseMusicStream(ByVal music As Music)
Declare Sub ResumeMusicStream(ByVal music As Music)
Declare Sub SeekMusicStream(ByVal music As Music, ByVal position As Single)
Declare Sub SetMusicVolume(ByVal music As Music, ByVal volume As Single)
Declare Sub SetMusicPitch(ByVal music As Music, ByVal pitch As Single)
Declare Sub SetMusicPan(ByVal music As Music, ByVal pan As Single)
Declare Function GetMusicTimeLength(ByVal music As Music) As Single
Declare Function GetMusicTimePlayed(ByVal music As Music) As Single
Declare Function LoadAudioStream(ByVal sampleRate As ULong, ByVal sampleSize As ULong, ByVal channels As ULong) As AudioStream
Declare Function IsAudioStreamReady(ByVal stream As AudioStream) As Boolean
Declare Sub UnloadAudioStream(ByVal stream As AudioStream)
Declare Sub UpdateAudioStream(ByVal stream As AudioStream, ByVal data As Const Any Ptr, ByVal frameCount As Long)
Declare Function IsAudioStreamProcessed(ByVal stream As AudioStream) As Boolean
Declare Sub PlayAudioStream(ByVal stream As AudioStream)
Declare Sub PauseAudioStream(ByVal stream As AudioStream)
Declare Sub ResumeAudioStream(ByVal stream As AudioStream)
Declare Function IsAudioStreamPlaying(ByVal stream As AudioStream) As Boolean
Declare Sub StopAudioStream(ByVal stream As AudioStream)
Declare Sub SetAudioStreamVolume(ByVal stream As AudioStream, ByVal volume As Single)
Declare Sub SetAudioStreamPitch(ByVal stream As AudioStream, ByVal pitch As Single)
Declare Sub SetAudioStreamPan(ByVal stream As AudioStream, ByVal pan As Single)
Declare Sub SetAudioStreamBufferSizeDefault(ByVal size As Long)
Declare Sub SetAudioStreamCallback(ByVal stream As AudioStream, ByVal callback As AudioCallback)
Declare Sub AttachAudioStreamProcessor(ByVal stream As AudioStream, ByVal processor As AudioCallback)
Declare Sub DetachAudioStreamProcessor(ByVal stream As AudioStream, ByVal processor As AudioCallback)
Declare Sub AttachAudioMixedProcessor(ByVal processor As AudioCallback)
Declare Sub DetachAudioMixedProcessor(ByVal processor As AudioCallback)

End Extern
End Namespace
Using RayLib
