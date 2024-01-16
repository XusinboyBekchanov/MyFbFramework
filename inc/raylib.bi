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
#define RL_RECTANGLE_TYPE
#define RL_VECTOR2_TYPE
#define RL_VECTOR3_TYPE
#define RL_VECTOR4_TYPE
#define RL_QUATERNION_TYPE
#define RL_MATRIX_TYPE

#define LIGHTGRAY RLColor( 200, 200, 200, 255 )
#define GRAY RLColor( 130, 130, 130, 255 )
#define DARKGRAY RLColor( 80, 80, 80, 255 )
#define YELLOW RLColor( 253, 249, 0, 255 )
#define GOLD RLColor( 255, 203, 0, 255 )
#define ORANGE RLColor( 255, 161, 0, 255 )
#define PINK RLColor( 255, 109, 194, 255 )
#define RED RLColor( 230, 41, 55, 255 )
#define MAROON RLColor( 190, 33, 55, 255 )
#define GREEN RLColor( 0, 228, 48, 255 )
#define LIME RLColor( 0, 158, 47, 255 )
#define DARKGREEN RLColor( 0, 117, 44, 255 )
#define SKYBLUE RLColor( 102, 191, 255, 255 )
#define BLUE RLColor( 0, 121, 241, 255 )
#define DARKBLUE RLColor( 0, 82, 172, 255 )
#define PURPLE RLColor( 200, 122, 255, 255 )
#define VIOLET RLColor( 135, 60, 190, 255 )
#define DARKPURPLE RLColor( 112, 31, 126, 255 )
#define BEIGE RLColor( 211, 176, 131, 255 )
#define BROWN RLColor( 127, 106, 79, 255 )
#define DARKBROWN RLColor( 76, 63, 47, 255 )
#define WHITE RLColor( 255, 255, 255, 255 )
#define BLACK RLColor( 0, 0, 0, 255 )
#define BLANK RLColor( 0, 0, 0, 0 )
#define MAGENTA RLColor( 255, 0, 255, 255 )
#define RAYWHITE RLColor( 245, 245, 245, 255 )

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

Type RLColor
	r As UByte
	g As UByte
	b As UByte
	a As UByte
	Declare Constructor()
	Declare Constructor(r As UByte, g As UByte, b As UByte, a As UByte)
End Type

Constructor RLColor(r As UByte, g As UByte, b As UByte, a As UByte)
	This.r = r
	This.g = g
	This.b = b
	This.a = a
End Constructor

Constructor RLColor()
End Constructor

Type Rectangle
	x As Single
	y As Single
	width_ As Single
	height_ As Single
	Declare Constructor()
	Declare Constructor(x As Single, y As Single, width_ As Single, height_ As Single)
End Type

Constructor Rectangle()
End Constructor

Constructor Rectangle(x As Single, y As Single, width_ As Single, height_ As Single)
	This.x = x
	This.y = y
	This.width_ = width_
	This.height_ = height_
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
	color As RLColor
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
	vScreenCenter As Single
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
	FLAG_MSAA_4X_HINT = &h00000020
	FLAG_INTERLACED_HINT = &h00010000
End Enum

Type TraceLogLevel As Long
Enum
	LOG_ALL = 0
	LOG_TRACE
	LOG_DEBUG
	LOG_INFO
	LOG_WARNING
	LOG_ERROR
	LOG_FATAL
	LOG_NONE
End Enum

Type KeyboardKey As Long
Enum
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
	KEY_MENU = 82
	KEY_VOLUME_UP = 24
	KEY_VOLUME_DOWN = 25
End Enum

Type MouseButton As Long
Enum
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

Type MouseCursor As Long
Enum
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

Type GamepadButton As Long
Enum
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

Type GamepadAxis As Long
Enum
	GAMEPAD_AXIS_LEFT_X = 0
	GAMEPAD_AXIS_LEFT_Y = 1
	GAMEPAD_AXIS_RIGHT_X = 2
	GAMEPAD_AXIS_RIGHT_Y = 3
	GAMEPAD_AXIS_LEFT_TRIGGER = 4
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5
End Enum

Type MaterialMapIndex As Long
Enum
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

Type ShaderLocationIndex As Long
Enum
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

Type ShaderUniformDataType As Long
Enum
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

Type ShaderAttributeDataType As Long
Enum
	SHADER_ATTRIB_FLOAT = 0
	SHADER_ATTRIB_VEC2
	SHADER_ATTRIB_VEC3
	SHADER_ATTRIB_VEC4
End Enum

Type PixelFormat As Long
Enum
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

Type TextureFilter As Long
Enum
	TEXTURE_FILTER_POINT = 0
	TEXTURE_FILTER_BILINEAR
	TEXTURE_FILTER_TRILINEAR
	TEXTURE_FILTER_ANISOTROPIC_4X
	TEXTURE_FILTER_ANISOTROPIC_8X
	TEXTURE_FILTER_ANISOTROPIC_16X
End Enum

Type TextureWrap As Long
Enum
	TEXTURE_WRAP_REPEAT = 0
	TEXTURE_WRAP_CLAMP
	TEXTURE_WRAP_MIRROR_REPEAT
	TEXTURE_WRAP_MIRROR_CLAMP
End Enum

Type CubemapLayout As Long
Enum
	CUBEMAP_LAYOUT_AUTO_DETECT = 0
	CUBEMAP_LAYOUT_LINE_VERTICAL
	CUBEMAP_LAYOUT_LINE_HORIZONTAL
	CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR
	CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE
	CUBEMAP_LAYOUT_PANORAMA
End Enum

Type FontType As Long
Enum
	FONT_DEFAULT = 0
	FONT_BITMAP
	FONT_SDF
End Enum

Type BlendMode As Long
Enum
	BLEND_ALPHA = 0
	BLEND_ADDITIVE
	BLEND_MULTIPLIED
	BLEND_ADD_COLORS
	BLEND_SUBTRACT_COLORS
	BLEND_ALPHA_PREMULTIPLY
	BLEND_CUSTOM
  BLEND_CUSTOM_SEPARATE
End Enum

Type Gesture As Long
Enum
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

Type CameraMode As Long
Enum
	CAMERA_CUSTOM = 0
	CAMERA_FREE
	CAMERA_ORBITAL
	CAMERA_FIRST_PERSON
	CAMERA_THIRD_PERSON
End Enum

Type CameraProjection As Long
Enum
	CAMERA_PERSPECTIVE = 0
	CAMERA_ORTHOGRAPHIC
End Enum

Type NPatchLayout As Long
Enum
	NPATCH_NINE_PATCH = 0
	NPATCH_THREE_PATCH_VERTICAL
	NPATCH_THREE_PATCH_HORIZONTAL
End Enum

Type TraceLogCallback As Sub(ByVal logLevel As Long, ByVal text As Const ZString Ptr, ByVal args As va_list)
Type LoadFileDataCallback As Function(ByVal fileName As Const ZString Ptr, ByVal bytesRead As ULong Ptr) As UByte Ptr
Type SaveFileDataCallback As Function(ByVal fileName As Const ZString Ptr, ByVal data_ As Any Ptr, ByVal bytesToWrite As ULong) As Boolean
Type LoadFileTextCallback As Function(ByVal fileName As Const ZString Ptr) As ZString Ptr
Type SaveFileTextCallback As Function(ByVal fileName As Const ZString Ptr, ByVal text As ZString Ptr) As Boolean

Declare Sub InitWindow(ByVal width_ As Long, ByVal height_ As Long, ByVal title As Const ZString Ptr)
Declare Function WindowShouldClose() As Boolean
Declare Sub CloseWindow()
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
Declare Sub MaximizeWindow()
Declare Sub MinimizeWindow()
Declare Sub RestoreWindow()
Declare Sub SetWindowIcon(ByVal image_ As Image)
Declare Sub SetWindowIcons(ByVal images As Image Ptr, ByVal count As Long)
Declare Sub SetWindowTitle(ByVal title As Const ZString Ptr)
Declare Sub SetWindowPosition(ByVal x As Long, ByVal y As Long)
Declare Sub SetWindowMonitor(ByVal monitor As Long)
Declare Sub SetWindowMinSize(ByVal width_ As Long, ByVal height_ As Long)
Declare Sub SetWindowSize(ByVal width_ As Long, ByVal height_ As Long)
Declare Sub SetWindowOpacity(ByVal opacity As Single)
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
Declare Sub SwapScreenBuffer()
Declare Sub PollInputEvents()
Declare Sub WaitTime(ByVal seconds As Double)
Declare Sub ShowCursor()
Declare Sub HideCursor()
Declare Function IsCursorHidden() As Boolean
Declare Sub EnableCursor()
Declare Sub DisableCursor()
Declare Function IsCursorOnScreen() As Boolean
Declare Sub ClearBackground(ByVal color As RLColor)
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
Declare Function IsShaderReady(ByVal shader As Shader) As Byte
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
Declare Function GetFPS() As Long
Declare Function GetFrameTime() As Single
Declare Function GetTime() As Double
Declare Function GetRandomValue(ByVal min As Long, ByVal max As Long) As Long
Declare Sub SetRandomSeed(ByVal seed As ULong)
Declare Sub TakeScreenshot(ByVal fileName As Const ZString Ptr)
Declare Sub SetConfigFlags(ByVal flags As ULong)
Declare Sub TraceLog(ByVal logLevel As Long, ByVal text As Const ZString Ptr, ...)
Declare Sub SetTraceLogLevel(ByVal logLevel As Long)
Declare Function MemAlloc(ByVal size As Long) As Any Ptr
Declare Function MemRealloc(ByVal ptr As Any ptr, ByVal size As Long) As Any ptr
Declare Sub MemFree(ByVal ptr As Any ptr)
Declare Sub OpenURL(ByVal url As Const ZString Ptr)
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
Declare Function EncodeDataBase64(ByVal data_ As Const UByte Ptr, ByVal dataSize As Long, ByVal outputSize As Long Ptr) As ZString Ptr
Declare Function DecodeDataBase64(ByVal data_ As Const UByte Ptr, ByVal outputSize As Long Ptr) As UByte Ptr
Declare Function IsKeyPressed(ByVal key As Long) As Boolean
Declare Function IsKeyDown(ByVal key As Long) As Boolean
Declare Function IsKeyReleased(ByVal key As Long) As Boolean
Declare Function IsKeyUp(ByVal key As Long) As Boolean
Declare Sub SetExitKey(ByVal key As Long)
Declare Function GetKeyPressed() As Long
Declare Function GetCharPressed() As Long
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
Declare Function IsGestureDetected(ByVal gesture As Long) As Boolean
Declare Function GetGestureDetected() As Long
Declare Function GetGestureHoldDuration() As Single
Declare Function GetGestureDragVector() As Vector2
Declare Function GetGestureDragAngle() As Single
Declare Function GetGesturePinchVector() As Vector2
Declare Function GetGesturePinchAngle() As Single
Declare Sub UpdateCamera(ByVal camera As Camera Ptr, ByVal mode As Long)
Declare Sub UpdateCameraPro(ByVal camera As Camera Ptr, ByVal movement As Vector3, ByVal rotation As Vector3, ByVal zoom As Single)
Declare Sub SetShapesTexture(ByVal texture As Texture2D, ByVal source As Rectangle)
Declare Sub DrawPixel(ByVal posX As Long, ByVal posY As Long, ByVal color As RLColor)
Declare Sub DrawPixelV(ByVal position As Vector2, ByVal color As RLColor)
Declare Sub DrawLine(ByVal startPosX As Long, ByVal startPosY As Long, ByVal endPosX As Long, ByVal endPosY As Long, ByVal color As RLColor)
Declare Sub DrawLineV(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal color As RLColor)
Declare Sub DrawLineEx(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal thick As Single, ByVal color As RLColor)
Declare Sub DrawLineBezier(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal thick As Single, ByVal color As RLColor)
Declare Sub DrawLineBezierQuad(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal controlPos As Vector2, ByVal thick As Single, ByVal color As RLColor)
Declare Sub DrawLineBezierCubic(ByVal startPos As Vector2, ByVal endPos As Vector2, ByVal startControlPos As Vector2, ByVal endControlPos As Vector2, ByVal thick As Single, ByVal color As RLColor)
Declare Sub DrawLineStrip(ByVal points As Vector2 Ptr, ByVal pointCount As Long, ByVal color As RLColor)
Declare Sub DrawCircle(ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Single, ByVal color As RLColor)
Declare Sub DrawCircleSector(ByVal center As Vector2, ByVal radius As Single, ByVal startAngle As Single, ByVal endAngle As Single, ByVal segments As Long, ByVal color As RLColor)
Declare Sub DrawCircleSectorLines(ByVal center As Vector2, ByVal radius As Single, ByVal startAngle As Single, ByVal endAngle As Single, ByVal segments As Long, ByVal color As RLColor)
Declare Sub DrawCircleGradient(ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Single, ByVal color1 As RLColor, ByVal color2 As RLColor)
Declare Sub DrawCircleV(ByVal center As Vector2, ByVal radius As Single, ByVal color As RLColor)
Declare Sub DrawCircleLines(ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Single, ByVal color As RLColor)
Declare Sub DrawEllipse(ByVal centerX As Long, ByVal centerY As Long, ByVal radiusH As Single, ByVal radiusV As Single, ByVal color As RLColor)
Declare Sub DrawEllipseLines(ByVal centerX As Long, ByVal centerY As Long, ByVal radiusH As Single, ByVal radiusV As Single, ByVal color As RLColor)
Declare Sub DrawRing(ByVal center As Vector2, ByVal innerRadius As Single, ByVal outerRadius As Single, ByVal startAngle As Single, ByVal endAngle As Single, ByVal segments As Long, ByVal color As RLColor)
Declare Sub DrawRingLines(ByVal center As Vector2, ByVal innerRadius As Single, ByVal outerRadius As Single, ByVal startAngle As Single, ByVal endAngle As Single, ByVal segments As Long, ByVal color As RLColor)
Declare Sub DrawRectangle(ByVal posX As Long, ByVal posY As Long, ByVal width_ As Long, ByVal height_ As Long, ByVal color As RLColor)
Declare Sub DrawRectangleV(ByVal position As Vector2, ByVal size As Vector2, ByVal color As RLColor)
Declare Sub DrawRectangleRec(ByVal rec As Rectangle, ByVal color As RLColor)
Declare Sub DrawRectanglePro(ByVal rec As Rectangle, ByVal origin As Vector2, ByVal rotation As Single, ByVal color As RLColor)
Declare Sub DrawRectangleGradientV(ByVal posX As Long, ByVal posY As Long, ByVal width_ As Long, ByVal height_ As Long, ByVal color1 As RLColor, ByVal color2 As RLColor)
Declare Sub DrawRectangleGradientH(ByVal posX As Long, ByVal posY As Long, ByVal width_ As Long, ByVal height_ As Long, ByVal color1 As RLColor, ByVal color2 As RLColor)
Declare Sub DrawRectangleGradientEx(ByVal rec As Rectangle, ByVal col1 As RLColor, ByVal col2 As RLColor, ByVal col3 As RLColor, ByVal col4 As RLColor)
Declare Sub DrawRectangleLines(ByVal posX As Long, ByVal posY As Long, ByVal width_ As Long, ByVal height_ As Long, ByVal color As RLColor)
Declare Sub DrawRectangleLinesEx(ByVal rec As Rectangle, ByVal lineThick As Single, ByVal color As RLColor)
Declare Sub DrawRectangleRounded(ByVal rec As Rectangle, ByVal roundness As Single, ByVal segments As Long, ByVal color As RLColor)
Declare Sub DrawRectangleRoundedLines(ByVal rec As Rectangle, ByVal roundness As Single, ByVal segments As Long, ByVal lineThick As Single, ByVal color As RLColor)
Declare Sub DrawTriangle(ByVal v1 As Vector2, ByVal v2 As Vector2, ByVal v3 As Vector2, ByVal color As RLColor)
Declare Sub DrawTriangleLines(ByVal v1 As Vector2, ByVal v2 As Vector2, ByVal v3 As Vector2, ByVal color As RLColor)
Declare Sub DrawTriangleFan(ByVal points As Vector2 Ptr, ByVal pointCount As Long, ByVal color As RLColor)
Declare Sub DrawTriangleStrip(ByVal points As Vector2 Ptr, ByVal pointCount As Long, ByVal color As RLColor)
Declare Sub DrawPoly(ByVal center As Vector2, ByVal sides As Long, ByVal radius As Single, ByVal rotation As Single, ByVal color As RLColor)
Declare Sub DrawPolyLines(ByVal center As Vector2, ByVal sides As Long, ByVal radius As Single, ByVal rotation As Single, ByVal color As RLColor)
Declare Sub DrawPolyLinesEx(ByVal center As Vector2, ByVal sides As Long, ByVal radius As Single, ByVal rotation As Single, ByVal lineThick As Single, ByVal color As RLColor)
Declare Function CheckCollisionRecs(ByVal rec1 As Rectangle, ByVal rec2 As Rectangle) As Boolean
Declare Function CheckCollisionCircles(ByVal center1 As Vector2, ByVal radius1 As Single, ByVal center2 As Vector2, ByVal radius2 As Single) As Boolean
Declare Function CheckCollisionCircleRec(ByVal center As Vector2, ByVal radius As Single, ByVal rec As Rectangle) As Boolean
Declare Function CheckCollisionPointRec(ByVal point_ As Vector2, ByVal rec As Rectangle) As Boolean
Declare Function CheckCollisionPointCircle(ByVal point_ As Vector2, ByVal center As Vector2, ByVal radius As Single) As Boolean
Declare Function CheckCollisionPointTriangle(ByVal point_ As Vector2, ByVal p1 As Vector2, ByVal p2 As Vector2, ByVal p3 As Vector2) As Boolean
Declare Function CheckCollisionPointPoly(ByVal point As Vector2, ByVal points As Vector2 Ptr, ByVal pointCount As Long) As Byte
Declare Function CheckCollisionLines(ByVal startPos1 As Vector2, ByVal endPos1 As Vector2, ByVal startPos2 As Vector2, ByVal endPos2 As Vector2, ByVal collisionPoint As Vector2 Ptr) As Boolean
Declare Function CheckCollisionPointLine(ByVal point_ As Vector2, ByVal p1 As Vector2, ByVal p2 As Vector2, ByVal threshold As Long) As Boolean
Declare Function GetCollisionRec(ByVal rec1 As Rectangle, ByVal rec2 As Rectangle) As Rectangle
Declare Function RL_LoadImage(ByVal fileName As Const ZString Ptr) As Image
Declare Function LoadImageSvg(ByVal fileName As Const ZString Ptr, ByVal width_ As Long, ByVal height_ As Long) As Image
Declare Function LoadImageRaw(ByVal fileName As Const ZString Ptr, ByVal width_ As Long, ByVal height_ As Long, ByVal format_ As Long, ByVal headerSize As Long) As Image
Declare Function LoadImageAnim(ByVal fileName As Const ZString Ptr, ByVal frames As Long Ptr) As Image
Declare Function LoadImageFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long) As Image
Declare Function LoadImageFromTexture(ByVal texture As Texture2D) As Image
Declare Function LoadImageFromScreen() As Image
Declare Function IsImageReady(ByVal image_ As Image) As Byte
Declare Sub UnloadImage(ByVal image_ As Image)
Declare Function ExportImage(ByVal image_ As Image, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function ExportImageAsCode(ByVal image_ As Image, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function GenImageColor(ByVal width_ As Long, ByVal height_ As Long, ByVal color As RLColor) As Image
Declare Function GenImageGradientV(ByVal width_ As Long, ByVal height_ As Long, ByVal top As RLColor, ByVal bottom As RLColor) As Image
Declare Function GenImageGradientH(ByVal width_ As Long, ByVal height_ As Long, ByVal left_ As RLColor, ByVal right_ As RLColor) As Image
Declare Function GenImageGradientRadial(ByVal width_ As Long, ByVal height_ As Long, ByVal density As Single, ByVal inner As RLColor, ByVal outer As RLColor) As Image
Declare Function GenImageChecked(ByVal width_ As Long, ByVal height_ As Long, ByVal checksX As Long, ByVal checksY As Long, ByVal col1 As RLColor, ByVal col2 As RLColor) As Image
Declare Function GenImageWhiteNoise(ByVal width_ As Long, ByVal height_ As Long, ByVal factor As Single) As Image
Declare Function GenImagePerlinNoise(ByVal width_ As Long, ByVal height_ As Long, ByVal offsetX As Long, ByVal offsetY As Long, ByVal scale As Single) As Image
Declare Function GenImageCellular(ByVal width_ As Long, ByVal height_ As Long, ByVal tileSize As Long) As Image
Declare Function GenImageText(ByVal width_ As Long, ByVal height_ As Long, ByVal text_ As Const ZString Ptr) As Image
Declare Function ImageCopy(ByVal image_ As Image) As Image
Declare Function ImageFromImage(ByVal image_ As Image, ByVal rec As Rectangle) As Image
Declare Function ImageText(ByVal text As Const ZString Ptr, ByVal fontSize As Long, ByVal color As RLColor) As Image
Declare Function ImageTextEx(ByVal font As Font, ByVal text As Const ZString Ptr, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As RLColor) As Image
Declare Sub ImageFormat(ByVal image_ As Image Ptr, ByVal newFormat As Long)
Declare Sub ImageToPOT(ByVal image_ As Image Ptr, ByVal fill As RLColor)
Declare Sub ImageCrop(ByVal image_ As Image Ptr, ByVal crop As Rectangle)
Declare Sub ImageAlphaCrop(ByVal image_ As Image Ptr, ByVal threshold As Single)
Declare Sub ImageAlphaClear(ByVal image_ As Image Ptr, ByVal color As RLColor, ByVal threshold As Single)
Declare Sub ImageAlphaMask(ByVal image_ As Image Ptr, ByVal alphaMask As Image)
Declare Sub ImageAlphaPremultiply(ByVal image_ As Image Ptr)
Declare Sub ImageBlurGaussian(ByVal image_ As Image Ptr, ByVal blurSize As Long)
Declare Sub ImageResize(ByVal image_ As Image Ptr, ByVal newWidth As Long, ByVal newHeight As Long)
Declare Sub ImageResizeNN(ByVal image_ As Image Ptr, ByVal newWidth As Long, ByVal newHeight As Long)
Declare Sub ImageResizeCanvas(ByVal image_ As Image Ptr, ByVal newWidth As Long, ByVal newHeight As Long, ByVal offsetX As Long, ByVal offsetY As Long, ByVal fill As RLColor)
Declare Sub ImageMipmaps(ByVal image_ As Image Ptr)
Declare Sub ImageDither(ByVal image_ As Image Ptr, ByVal rBpp As Long, ByVal gBpp As Long, ByVal bBpp As Long, ByVal aBpp As Long)
Declare Sub ImageFlipVertical(ByVal image_ As Image Ptr)
Declare Sub ImageFlipHorizontal(ByVal image_ As Image Ptr)
Declare Sub ImageRotateCW(ByVal image_ As Image Ptr)
Declare Sub ImageRotateCCW(ByVal image_ As Image Ptr)
Declare Sub ImageColorTint(ByVal image_ As Image Ptr, ByVal color As RLColor)
Declare Sub ImageColorInvert(ByVal image_ As Image Ptr)
Declare Sub ImageColorGrayscale(ByVal image_ As Image Ptr)
Declare Sub ImageColorContrast(ByVal image_ As Image Ptr, ByVal contrast As Single)
Declare Sub ImageColorBrightness(ByVal image_ As Image Ptr, ByVal brightness As Long)
Declare Sub ImageColorReplace(ByVal image_ As Image Ptr, ByVal color As RLColor, ByVal replace As RLColor)
Declare Function LoadImageColors(ByVal image_ As Image) As RLColor Ptr
Declare Function LoadImagePalette(ByVal image_ As Image, ByVal maxPaletteSize As Long, ByVal colorCount As Long Ptr) As RLColor Ptr
Declare Sub UnloadImageColors(ByVal colors As RLColor Ptr)
Declare Sub UnloadImagePalette(ByVal colors As RLColor Ptr)
Declare Function GetImageAlphaBorder(ByVal image_ As Image, ByVal threshold As Single) As Rectangle
Declare Function GetImageColor(ByVal image_ As Image, ByVal x As Long, ByVal y As Long) As RLColor
Declare Sub ImageClearBackground(ByVal dst As Image Ptr, ByVal color As RLColor)
Declare Sub ImageDrawPixel(ByVal dst As Image Ptr, ByVal posX As Long, ByVal posY As Long, ByVal color As RLColor)
Declare Sub ImageDrawPixelV(ByVal dst As Image Ptr, ByVal position As Vector2, ByVal color As RLColor)
Declare Sub ImageDrawLine(ByVal dst As Image Ptr, ByVal startPosX As Long, ByVal startPosY As Long, ByVal endPosX As Long, ByVal endPosY As Long, ByVal color As RLColor)
Declare Sub ImageDrawLineV(ByVal dst As Image Ptr, ByVal start As Vector2, ByVal end_ As Vector2, ByVal color As RLColor)
Declare Sub ImageDrawCircle(ByVal dst As Image Ptr, ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Long, ByVal color As RLColor)
Declare Sub ImageDrawCircleV(ByVal dst As Image Ptr, ByVal center As Vector2, ByVal radius As Long, ByVal color As RLColor)
Declare Sub ImageDrawCircleLines(ByVal dst As Image Ptr, ByVal centerX As Long, ByVal centerY As Long, ByVal radius As Long, ByVal color_ As RLColor)
Declare Sub ImageDrawCircleLinesV(ByVal dst As Image Ptr, ByVal center As Vector2, ByVal radius As Long, ByVal color_ As RLColor)
Declare Sub ImageDrawRectangle(ByVal dst As Image Ptr, ByVal posX As Long, ByVal posY As Long, ByVal width_ As Long, ByVal height_ As Long, ByVal color As RLColor)
Declare Sub ImageDrawRectangleV(ByVal dst As Image Ptr, ByVal position As Vector2, ByVal size As Vector2, ByVal color As RLColor)
Declare Sub ImageDrawRectangleRec(ByVal dst As Image Ptr, ByVal rec As Rectangle, ByVal color As RLColor)
Declare Sub ImageDrawRectangleLines(ByVal dst As Image Ptr, ByVal rec As Rectangle, ByVal thick As Long, ByVal color As RLColor)
Declare Sub ImageDraw(ByVal dst As Image Ptr, ByVal src As Image, ByVal srcRec As Rectangle, ByVal dstRec As Rectangle, ByVal tint As RLColor)
Declare Sub ImageDrawText(ByVal dst As Image Ptr, ByVal text As Const ZString Ptr, ByVal posX As Long, ByVal posY As Long, ByVal fontSize As Long, ByVal color As RLColor)
Declare Sub ImageDrawTextEx(ByVal dst As Image Ptr, ByVal font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As RLColor)
Declare Function LoadTexture(ByVal fileName As Const ZString Ptr) As Texture2D
Declare Function LoadTextureFromImage(ByVal image_ As Image) As Texture2D
Declare Function LoadTextureCubemap(ByVal image_ As Image, ByVal layout As Long) As TextureCubemap
Declare Function LoadRenderTexture(ByVal width_ As Long, ByVal height_ As Long) As RenderTexture2D
Declare Function IsTextureReady(ByVal texture As Texture2D) As Byte
Declare Sub UnloadTexture(ByVal texture As Texture2D)
Declare Function IsRenderTextureReady(ByVal target As RenderTexture2D) As Byte
Declare Sub UnloadRenderTexture(ByVal target As RenderTexture2D)
Declare Sub UpdateTexture(ByVal texture As Texture2D, ByVal pixels As Const Any Ptr)
Declare Sub UpdateTextureRec(ByVal texture As Texture2D, ByVal rec As Rectangle, ByVal pixels As Const Any Ptr)
Declare Sub GenTextureMipmaps(ByVal texture As Texture2D Ptr)
Declare Sub SetTextureFilter(ByVal texture As Texture2D, ByVal filter As Long)
Declare Sub SetTextureWrap(ByVal texture As Texture2D, ByVal wrap As Long)
Declare Sub DrawTexture(ByVal texture As Texture2D, ByVal posX As Long, ByVal posY As Long, ByVal tint As RLColor)
Declare Sub DrawTextureV(ByVal texture As Texture2D, ByVal position As Vector2, ByVal tint As RLColor)
Declare Sub DrawTextureEx(ByVal texture As Texture2D, ByVal position As Vector2, ByVal rotation As Single, ByVal scale As Single, ByVal tint As RLColor)
Declare Sub DrawTextureRec(ByVal texture As Texture2D, ByVal source As Rectangle, ByVal position As Vector2, ByVal tint As RLColor)
Declare Sub DrawTexturePro(ByVal texture As Texture2D, ByVal source As Rectangle, ByVal dest As Rectangle, ByVal origin As Vector2, ByVal rotation As Single, ByVal tint As RLColor)
Declare Sub DrawTextureNPatch(ByVal texture As Texture2D, ByVal nPatchInfo As NPatchInfo, ByVal dest As Rectangle, ByVal origin As Vector2, ByVal rotation As Single, ByVal tint As RLColor)
Declare Function Fade(ByVal color As RLColor, ByVal alpha_ As Single) As RLColor
Declare Function ColorToInt(ByVal color_ As RLColor) As Long
Declare Function ColorNormalize(ByVal color_ As RLColor) As Vector4
Declare Function ColorFromNormalized(ByVal normalized As Vector4) As RLColor
Declare Function ColorToHSV(ByVal color As RLColor) As Vector3
Declare Function ColorFromHSV(ByVal hue As Single, ByVal saturation As Single, ByVal value As Single) As RLColor
Declare Function ColorTint(ByVal color_ As RLColor, ByVal tint As RLColor) As RLColor
Declare Function ColorBrightness(ByVal color_ As RLColor, ByVal factor As Single) As RLColor
Declare Function ColorContrast(ByVal color_ As RLColor, ByVal contrast As Single) As RLColor
Declare Function ColorAlpha(ByVal color_ As RLColor, ByVal alpha_ As Single) As RLColor
Declare Function ColorAlphaBlend(ByVal dst As RLColor, ByVal src As RLColor, ByVal tint As RLColor) As RLColor
Declare Function GetColor(ByVal hexValue As ULong) As RLColor
Declare Function GetPixelColor(ByVal srcPtr As Any Ptr, ByVal format_ As Long) As RLColor
Declare Sub SetPixelColor(ByVal dstPtr As Any Ptr, ByVal color As RLColor, ByVal format_ As Long)
Declare Function GetPixelDataSize(ByVal width_ As Long, ByVal height_ As Long, ByVal format_ As Long) As Long
Declare Function GetFontDefault() As Font
Declare Function LoadFont(ByVal fileName As Const ZString Ptr) As Font
Declare Function LoadFontEx(ByVal fileName As Const ZString Ptr, ByVal fontSize As Long, ByVal fontChars As Long Ptr, ByVal glyphCount As Long) As Font
Declare Function LoadFontFromImage(ByVal image_ As Image, ByVal key As RLColor, ByVal firstChar As Long) As Font
Declare Function LoadFontFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long, ByVal fontSize As Long, ByVal fontChars As Long Ptr, ByVal glyphCount As Long) As Font
Declare Function IsFontReady(ByVal font As Font) As Byte
Declare Function LoadFontData(ByVal fileData As Const UByte Ptr, ByVal dataSize As Long, ByVal fontSize As Long, ByVal fontChars As Long Ptr, ByVal glyphCount As Long, ByVal type As Long) As GlyphInfo Ptr
Declare Function GenImageFontAtlas(ByVal chars As Const GlyphInfo Ptr, ByVal recs As Rectangle Ptr Ptr, ByVal glyphCount As Long, ByVal fontSize As Long, ByVal padding As Long, ByVal packMethod As Long) As Image
Declare Sub UnloadFontData(ByVal chars As GlyphInfo Ptr, ByVal glyphCount As Long)
Declare Sub UnloadFont(ByVal font As Font)
Declare Function ExportFontAsCode(ByVal font As Font, ByVal fileName As Const ZString Ptr) As Boolean
Declare Sub DrawFPS(ByVal posX As Long, ByVal posY As Long)
Declare Sub DrawText(ByVal text As Const ZString Ptr, ByVal posX As Long, ByVal posY As Long, ByVal fontSize As Long, ByVal color As RLColor)
Declare Sub DrawTextEx(ByVal font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As RLColor)
Declare Sub DrawTextPro(ByVal font As Font, ByVal text As Const ZString Ptr, ByVal position As Vector2, ByVal origin As Vector2, ByVal rotation As Single, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As RLColor)
Declare Sub DrawTextCodepoint(ByVal font As Font, ByVal codepoint As Long, ByVal position As Vector2, ByVal fontSize As Single, ByVal tint As RLColor)
Declare Sub DrawTextCodepoints(ByVal font As Font, ByVal codepoints As Const Long Ptr, ByVal count As Long, ByVal position As Vector2, ByVal fontSize As Single, ByVal spacing As Single, ByVal tint As RLColor)
Declare Function MeasureText(ByVal text As Const ZString Ptr, ByVal fontSize As Long) As Long
Declare Function MeasureTextEx(ByVal font As Font, ByVal text As Const ZString Ptr, ByVal fontSize As Single, ByVal spacing As Single) As Vector2
Declare Function GetGlyphIndex(ByVal font As Font, ByVal codepoint As Long) As Long
Declare Function GetGlyphInfo(ByVal font As Font, ByVal codepoint As Long) As GlyphInfo
Declare Function GetGlyphAtlasRec(ByVal font As Font, ByVal codepoint As Long) As Rectangle
Declare Function LoadUTF8(ByVal codepoints As Const Long Ptr, ByVal length_ As Long) As ZString Ptr
Declare Sub UnloadUTF8(ByVal text As ZString Ptr)
Declare Function LoadCodepoints(ByVal text_ As Const ZString Ptr, ByVal count As Long Ptr) As Long Ptr
Declare Sub UnloadCodepoints(ByVal codepoints As Long Ptr)
Declare Function GetCodepoint(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function GetCodepointNext(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function GetCodepointPrevious(ByVal text As Const ZString Ptr, ByVal codepointSize As Long Ptr) As Long
Declare Function CodepointToUTF8(ByVal codepoint As Long, ByVal utf8Size As Long Ptr) As Const ZString Ptr
Declare Function TextCodepointsToUTF8(ByVal codepoints As Const Long Ptr, ByVal length As Long) As ZString Ptr
Declare Function TextCopy(ByVal dst As ZString Ptr, ByVal src As Const ZString Ptr) As Long
Declare Function TextIsEqual(ByVal text1 As Const ZString Ptr, ByVal text2 As Const ZString Ptr) As Boolean
Declare Function TextLength(ByVal text As Const ZString Ptr) As ULong
Declare Function TextFormat(ByVal text As Const ZString Ptr, ...) As Const ZString Ptr
Declare Function TextSubtext(ByVal text As Const ZString Ptr, ByVal position As Long, ByVal length As Long) As Const ZString Ptr
Declare Function TextReplace(ByVal text As ZString Ptr, ByVal replace As Const ZString Ptr, ByVal by As Const ZString Ptr) As ZString Ptr
Declare Function TextInsert(ByVal text As Const ZString Ptr, ByVal insert As Const ZString Ptr, ByVal position As Long) As ZString Ptr
Declare Function TextJoin(ByVal textList As Const ZString Ptr Ptr, ByVal count As Long, ByVal delimiter As Const ZString Ptr) As Const ZString Ptr
Declare Function TextSplit(ByVal text As Const ZString Ptr, ByVal delimiter As Byte, ByVal count As Long Ptr) As Const ZString Ptr Ptr
Declare Sub TextAppend(ByVal text As ZString Ptr, ByVal append As Const ZString Ptr, ByVal position As Long Ptr)
Declare Function TextFindIndex(ByVal text As Const ZString Ptr, ByVal find As Const ZString Ptr) As Long
Declare Function TextToUpper(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToLower(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToPascal(ByVal text As Const ZString Ptr) As Const ZString Ptr
Declare Function TextToInteger(ByVal text As Const ZString Ptr) As Long
Declare Sub DrawLine3D(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal color As RLColor)
Declare Sub DrawPoint3D(ByVal position As Vector3, ByVal color As RLColor)
Declare Sub DrawCircle3D(ByVal center As Vector3, ByVal radius As Single, ByVal rotationAxis As Vector3, ByVal rotationAngle As Single, ByVal color As RLColor)
Declare Sub DrawTriangle3D(ByVal v1 As Vector3, ByVal v2 As Vector3, ByVal v3 As Vector3, ByVal color As RLColor)
Declare Sub DrawTriangleStrip3D(ByVal points As Vector3 Ptr, ByVal pointCount As Long, ByVal color As RLColor)
Declare Sub DrawCube(ByVal position As Vector3, ByVal width_ As Single, ByVal height_ As Single, ByVal length As Single, ByVal color As RLColor)
Declare Sub DrawCubeV(ByVal position As Vector3, ByVal size As Vector3, ByVal color As RLColor)
Declare Sub DrawCubeWires(ByVal position As Vector3, ByVal width_ As Single, ByVal height_ As Single, ByVal length As Single, ByVal color As RLColor)
Declare Sub DrawCubeWiresV(ByVal position As Vector3, ByVal size As Vector3, ByVal color As RLColor)
Declare Sub DrawSphere(ByVal centerPos As Vector3, ByVal radius As Single, ByVal color As RLColor)
Declare Sub DrawSphereEx(ByVal centerPos As Vector3, ByVal radius As Single, ByVal rings As Long, ByVal slices As Long, ByVal color As RLColor)
Declare Sub DrawSphereWires(ByVal centerPos As Vector3, ByVal radius As Single, ByVal rings As Long, ByVal slices As Long, ByVal color As RLColor)
Declare Sub DrawCylinder(ByVal position As Vector3, ByVal radiusTop As Single, ByVal radiusBottom As Single, ByVal height_ As Single, ByVal slices As Long, ByVal color As RLColor)
Declare Sub DrawCylinderEx(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal startRadius As Single, ByVal endRadius As Single, ByVal sides As Long, ByVal color As RLColor)
Declare Sub DrawCylinderWires(ByVal position As Vector3, ByVal radiusTop As Single, ByVal radiusBottom As Single, ByVal height_ As Single, ByVal slices As Long, ByVal color As RLColor)
Declare Sub DrawCylinderWiresEx(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal startRadius As Single, ByVal endRadius As Single, ByVal sides As Long, ByVal color As RLColor)
Declare Sub DrawCapsule(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal radius As Single, ByVal slices As Long, ByVal rings As Long, ByVal color_ As RLColor)
Declare Sub DrawCapsuleWires(ByVal startPos As Vector3, ByVal endPos As Vector3, ByVal radius As Single, ByVal slices As Long, ByVal rings As Long, ByVal color_ As RLColor)
Declare Sub DrawPlane(ByVal centerPos As Vector3, ByVal size As Vector2, ByVal color As RLColor)
Declare Sub DrawRay(ByVal ray As Ray, ByVal color As RLColor)
Declare Sub DrawGrid(ByVal slices As Long, ByVal spacing As Single)
Declare Function LoadModel(ByVal fileName As Const ZString Ptr) As Model
Declare Function LoadModelFromMesh(ByVal mesh As Mesh) As Model
Declare Function IsModelReady(ByVal model As Model) As Byte
Declare Sub UnloadModel(ByVal model As Model)
Declare Function GetModelBoundingBox(ByVal model As Model) As BoundingBox
Declare Sub DrawModel(ByVal model As Model, ByVal position As Vector3, ByVal scale As Single, ByVal tint As RLColor)
Declare Sub DrawModelEx(ByVal model As Model, ByVal position As Vector3, ByVal rotationAxis As Vector3, ByVal rotationAngle As Single, ByVal scale As Vector3, ByVal tint As RLColor)
Declare Sub DrawModelWires(ByVal model As Model, ByVal position As Vector3, ByVal scale As Single, ByVal tint As RLColor)
Declare Sub DrawModelWiresEx(ByVal model As Model, ByVal position As Vector3, ByVal rotationAxis As Vector3, ByVal rotationAngle As Single, ByVal scale As Vector3, ByVal tint As RLColor)
Declare Sub DrawBoundingBox(ByVal box As BoundingBox, ByVal color As RLColor)
Declare Sub DrawBillboard(ByVal camera As Camera, ByVal texture As Texture2D, ByVal position As Vector3, ByVal size As Single, ByVal tint As RLColor)
Declare Sub DrawBillboardRec(ByVal camera As Camera, ByVal texture As Texture2D, ByVal source As Rectangle, ByVal position As Vector3, ByVal size As Vector2, ByVal tint As RLColor)
Declare Sub DrawBillboardPro(ByVal camera As Camera, ByVal texture As Texture2D, ByVal source As Rectangle, ByVal position As Vector3, ByVal up As Vector3, ByVal size As Vector2, ByVal origin As Vector2, ByVal rotation As Single, ByVal tint As RLColor)
Declare Sub UploadMesh(ByVal mesh As Mesh Ptr, ByVal dynamic As Boolean)
Declare Sub UpdateMeshBuffer(ByVal mesh As Mesh, ByVal index As Long, ByVal data_ As Const Any Ptr, ByVal dataSize As Long, ByVal offset As Long)
Declare Sub UnloadMesh(ByVal mesh As Mesh)
Declare Sub DrawMesh(ByVal mesh As Mesh, ByVal material As Material, ByVal transform As Matrix)
Declare Sub DrawMeshInstanced(ByVal mesh As Mesh, ByVal material As Material, ByVal transforms As Const Matrix Ptr, ByVal instances As Long)
Declare Function ExportMesh(ByVal mesh As Mesh, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function GetMeshBoundingBox(ByVal mesh As Mesh) As BoundingBox
Declare Sub GenMeshTangents(ByVal mesh As Mesh Ptr)
Declare Function GenMeshPoly(ByVal sides As Long, ByVal radius As Single) As Mesh
Declare Function GenMeshPlane(ByVal width_ As Single, ByVal length As Single, ByVal resX As Long, ByVal resZ As Long) As Mesh
Declare Function GenMeshCube(ByVal width_ As Single, ByVal height_ As Single, ByVal length As Single) As Mesh
Declare Function GenMeshSphere(ByVal radius As Single, ByVal rings As Long, ByVal slices As Long) As Mesh
Declare Function GenMeshHemiSphere(ByVal radius As Single, ByVal rings As Long, ByVal slices As Long) As Mesh
Declare Function GenMeshCylinder(ByVal radius As Single, ByVal height_ As Single, ByVal slices As Long) As Mesh
Declare Function GenMeshCone(ByVal radius As Single, ByVal height_ As Single, ByVal slices As Long) As Mesh
Declare Function GenMeshTorus(ByVal radius As Single, ByVal size As Single, ByVal radSeg As Long, ByVal sides As Long) As Mesh
Declare Function GenMeshKnot(ByVal radius As Single, ByVal size As Single, ByVal radSeg As Long, ByVal sides As Long) As Mesh
Declare Function GenMeshHeightmap(ByVal heightmap As Image, ByVal size As Vector3) As Mesh
Declare Function GenMeshCubicmap(ByVal cubicmap As Image, ByVal cubeSize As Vector3) As Mesh
Declare Function LoadMaterials(ByVal fileName As Const ZString Ptr, ByVal materialCount As Long Ptr) As Material Ptr
Declare Function LoadMaterialDefault() As Material
Declare Function IsMaterialReady(ByVal material As Material) As Byte
Declare Sub UnloadMaterial(ByVal material As Material)
Declare Sub SetMaterialTexture(ByVal material As Material Ptr, ByVal mapType As Long, ByVal texture As Texture2D)
Declare Sub SetModelMeshMaterial(ByVal model As Model Ptr, ByVal meshId As Long, ByVal materialId As Long)
Declare Function LoadModelAnimations(ByVal fileName As Const ZString Ptr, ByVal animCount As ULong Ptr) As ModelAnimation Ptr
Declare Sub UpdateModelAnimation(ByVal model As Model, ByVal anim As ModelAnimation, ByVal frame As Long)
Declare Sub UnloadModelAnimation(ByVal anim As ModelAnimation)
Declare Sub UnloadModelAnimations(ByVal animations As ModelAnimation Ptr, ByVal count As ULong)
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
Declare Function LoadWave(ByVal fileName As Const ZString Ptr) As Wave
Declare Function LoadWaveFromMemory(ByVal fileType As Const ZString Ptr, ByVal fileData As Const UByte Ptr, ByVal dataSize As Long) As Wave
Declare Function IsWaveReady(ByVal wave As Wave) As Byte
Declare Function LoadSound(ByVal fileName As Const ZString Ptr) As Sound
Declare Function LoadSoundFromWave(ByVal wave As Wave) As Sound
Declare Function IsSoundReady(ByVal sound As Sound) As Byte
Declare Sub UpdateSound(ByVal sound As Sound, ByVal data_ As Const Any Ptr, ByVal sampleCount As Long)
Declare Sub UnloadWave(ByVal wave As Wave)
Declare Sub UnloadSound(ByVal sound As Sound)
Declare Function ExportWave(ByVal wave As Wave, ByVal fileName As Const ZString Ptr) As Boolean
Declare Function ExportWaveAsCode(ByVal wave As Wave, ByVal fileName As Const ZString Ptr) As Boolean
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
Declare Function LoadMusicStreamFromMemory(ByVal fileType As Const ZString Ptr, ByVal data_ As Const UByte Ptr, ByVal dataSize As Long) As Music
Declare Function IsMusicReady(ByVal music As Music) As Byte
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
Declare Function IsAudioStreamReady(ByVal stream As AudioStream) As Byte
Declare Sub UnloadAudioStream(ByVal stream As AudioStream)
Declare Sub UpdateAudioStream(ByVal stream As AudioStream, ByVal data_ As Const Any Ptr, ByVal frameCount As Long)
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
