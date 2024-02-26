#pragma once

#include once "stdbool.bi"

Extern "C"

#define RLGL_H
#define RLGL_VERSION "4.5"
#define RLAPI
#define TRACELOG(level, __VA_ARGS__...) 0
#define TRACELOGD(__VA_ARGS__...) 0
#define RL_MALLOC(sz) malloc(sz)
#define RL_CALLOC(n, sz) calloc(n, sz)
#define RL_REALLOC(n, sz) realloc(n, sz)
#define RL_FREE(p) free(p)
#define GRAPHICS_API_OPENGL_33
#define RLGL_RENDER_TEXTURES_HINT
Const RL_DEFAULT_BATCH_BUFFER_ELEMENTS = 8192
Const RL_DEFAULT_BATCH_BUFFERS = 1
Const RL_DEFAULT_BATCH_DRAWCALLS = 256
Const RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS = 4
Const RL_MAX_MATRIX_STACK_SIZE = 32
Const RL_MAX_SHADER_LOCATIONS = 32
Const RL_CULL_DISTANCE_NEAR = 0.01
Const RL_CULL_DISTANCE_FAR = 1000.0
Const RL_TEXTURE_WRAP_S = &h2802
Const RL_TEXTURE_WRAP_T = &h2803
Const RL_TEXTURE_MAG_FILTER = &h2800
Const RL_TEXTURE_MIN_FILTER = &h2801
Const RL_TEXTURE_FILTER_NEAREST = &h2600
Const RL_TEXTURE_FILTER_LINEAR = &h2601
Const RL_TEXTURE_FILTER_MIP_NEAREST = &h2700
Const RL_TEXTURE_FILTER_NEAREST_MIP_LINEAR = &h2702
Const RL_TEXTURE_FILTER_LINEAR_MIP_NEAREST = &h2701
Const RL_TEXTURE_FILTER_MIP_LINEAR = &h2703
Const RL_TEXTURE_FILTER_ANISOTROPIC = &h3000
Const RL_TEXTURE_MIPMAP_BIAS_RATIO = &h4000
Const RL_TEXTURE_WRAP_REPEAT = &h2901
Const RL_TEXTURE_WRAP_CLAMP = &h812F
Const RL_TEXTURE_WRAP_MIRROR_REPEAT = &h8370
Const RL_TEXTURE_WRAP_MIRROR_CLAMP = &h8742
Const RL_MODELVIEW = &h1700
Const RL_PROJECTION = &h1701
Const RL_TEXTURE = &h1702
Const RL_LINES = &h0001
Const RL_TRIANGLES = &h0004
Const RL_QUADS = &h0007
Const RL_UNSIGNED_BYTE = &h1401
Const RL_FLOAT = &h1406
Const RL_STREAM_DRAW = &h88E0
Const RL_STREAM_READ = &h88E1
Const RL_STREAM_COPY = &h88E2
Const RL_STATIC_DRAW = &h88E4
Const RL_STATIC_READ = &h88E5
Const RL_STATIC_COPY = &h88E6
Const RL_DYNAMIC_DRAW = &h88E8
Const RL_DYNAMIC_READ = &h88E9
Const RL_DYNAMIC_COPY = &h88EA
Const RL_FRAGMENT_SHADER = &h8B30
Const RL_VERTEX_SHADER = &h8B31
Const RL_COMPUTE_SHADER = &h91B9
const RL_ZERO = 0
Const RL_ONE = 1
Const RL_SRC_COLOR = &h0300
Const RL_ONE_MINUS_SRC_COLOR = &h0301
Const RL_SRC_ALPHA = &h0302
Const RL_ONE_MINUS_SRC_ALPHA = &h0303
Const RL_DST_ALPHA = &h0304
Const RL_ONE_MINUS_DST_ALPHA = &h0305
Const RL_DST_COLOR = &h0306
Const RL_ONE_MINUS_DST_COLOR = &h0307
Const RL_SRC_ALPHA_SATURATE = &h0308
Const RL_CONSTANT_COLOR = &h8001
Const RL_ONE_MINUS_CONSTANT_COLOR = &h8002
Const RL_CONSTANT_ALPHA = &h8003
Const RL_ONE_MINUS_CONSTANT_ALPHA = &h8004
Const RL_FUNC_ADD = &h8006
Const RL_MIN = &h8007
Const RL_MAX = &h8008
Const RL_FUNC_SUBTRACT = &h800A
Const RL_FUNC_REVERSE_SUBTRACT = &h800B
Const RL_BLEND_EQUATION = &h8009
Const RL_BLEND_EQUATION_RGB = &h8009
Const RL_BLEND_EQUATION_ALPHA = &h883D
Const RL_BLEND_DST_RGB = &h80C8
Const RL_BLEND_SRC_RGB = &h80C9
Const RL_BLEND_DST_ALPHA = &h80CA
Const RL_BLEND_SRC_ALPHA = &h80CB
Const RL_BLEND_COLOR = &h8005
Const RL_READ_FRAMEBUFFER = &h8CA8
const RL_DRAW_FRAMEBUFFER = &h8CA9

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

#define RL_MATRIX_TYPE

Type rlVertexBuffer
	elementCount As Long
	vertices As Single Ptr
	texcoords As Single Ptr
	colors As UByte Ptr
	indices As ULong Ptr
	vaoId as ulong
	vboId(0 To 3) As ULong
End Type

Type rlDrawCall
	mode As Long
	vertexCount As Long
	vertexAlignment As Long
	textureId As ULong
End Type

Type rlRenderBatch
	bufferCount As Long
	currentBuffer As Long
	vertexBuffer As rlVertexBuffer Ptr
	draws As rlDrawCall Ptr
	drawCounter As Long
	currentDepth As Single
End Type

Type rlGlVersion As Long
Enum
	RL_OPENGL_11 = 1
	RL_OPENGL_21
	RL_OPENGL_33
	RL_OPENGL_43
	RL_OPENGL_ES_20
	RL_OPENGL_ES_30
End Enum

Type rlTraceLogLevel As Long
Enum
	RL_LOG_ALL = 0
	RL_LOG_TRACE
	RL_LOG_DEBUG
	RL_LOG_INFO
	RL_LOG_WARNING
	RL_LOG_ERROR
	RL_LOG_FATAL
	RL_LOG_NONE
End Enum

Type rlPixelFormat As Long
Enum
	RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1
	RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA
	RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5
	RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8
	RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1
	RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4
	RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
	RL_PIXELFORMAT_UNCOMPRESSED_R32
	RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32
	RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
	RL_PIXELFORMAT_UNCOMPRESSED_R16
	RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16
	RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16A16
	RL_PIXELFORMAT_COMPRESSED_DXT1_RGB
	RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA
	RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA
	RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA
	RL_PIXELFORMAT_COMPRESSED_ETC1_RGB
	RL_PIXELFORMAT_COMPRESSED_ETC2_RGB
	RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA
	RL_PIXELFORMAT_COMPRESSED_PVRT_RGB
	RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA
	RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA
	RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA
End Enum

Type rlTextureFilter As Long
Enum
	RL_TEXTURE_FILTER_POINT = 0
	RL_TEXTURE_FILTER_BILINEAR
	RL_TEXTURE_FILTER_TRILINEAR
	RL_TEXTURE_FILTER_ANISOTROPIC_4X
	RL_TEXTURE_FILTER_ANISOTROPIC_8X
	RL_TEXTURE_FILTER_ANISOTROPIC_16X
End Enum

Type rlBlendMode As Long
Enum
	RL_BLEND_ALPHA = 0
	RL_BLEND_ADDITIVE
	RL_BLEND_MULTIPLIED
	RL_BLEND_ADD_COLORS
	RL_BLEND_SUBTRACT_COLORS
	RL_BLEND_ALPHA_PREMULTIPLY
	RL_BLEND_CUSTOM
	RL_BLEND_CUSTOM_SEPARATE
End Enum

Type rlShaderLocationIndex As Long
Enum
	RL_SHADER_LOC_VERTEX_POSITION = 0
	RL_SHADER_LOC_VERTEX_TEXCOORD01
	RL_SHADER_LOC_VERTEX_TEXCOORD02
	RL_SHADER_LOC_VERTEX_NORMAL
	RL_SHADER_LOC_VERTEX_TANGENT
	RL_SHADER_LOC_VERTEX_COLOR
	RL_SHADER_LOC_MATRIX_MVP
	RL_SHADER_LOC_MATRIX_VIEW
	RL_SHADER_LOC_MATRIX_PROJECTION
	RL_SHADER_LOC_MATRIX_MODEL
	RL_SHADER_LOC_MATRIX_NORMAL
	RL_SHADER_LOC_VECTOR_VIEW
	RL_SHADER_LOC_COLOR_DIFFUSE
	RL_SHADER_LOC_COLOR_SPECULAR
	RL_SHADER_LOC_COLOR_AMBIENT
	RL_SHADER_LOC_MAP_ALBEDO
	RL_SHADER_LOC_MAP_METALNESS
	RL_SHADER_LOC_MAP_NORMAL
	RL_SHADER_LOC_MAP_ROUGHNESS
	RL_SHADER_LOC_MAP_OCCLUSION
	RL_SHADER_LOC_MAP_EMISSION
	RL_SHADER_LOC_MAP_HEIGHT
	RL_SHADER_LOC_MAP_CUBEMAP
	RL_SHADER_LOC_MAP_IRRADIANCE
	RL_SHADER_LOC_MAP_PREFILTER
	RL_SHADER_LOC_MAP_BRDF
End Enum

Const RL_SHADER_LOC_MAP_DIFFUSE = RL_SHADER_LOC_MAP_ALBEDO
Const RL_SHADER_LOC_MAP_SPECULAR = RL_SHADER_LOC_MAP_METALNESS

Type rlShaderUniformDataType As Long
Enum
	RL_SHADER_UNIFORM_FLOAT = 0
	RL_SHADER_UNIFORM_VEC2
	RL_SHADER_UNIFORM_VEC3
	RL_SHADER_UNIFORM_VEC4
	RL_SHADER_UNIFORM_INT
	RL_SHADER_UNIFORM_IVEC2
	RL_SHADER_UNIFORM_IVEC3
	RL_SHADER_UNIFORM_IVEC4
	RL_SHADER_UNIFORM_SAMPLER2D
End Enum

Type rlShaderAttributeDataType As Long
Enum
	RL_SHADER_ATTRIB_FLOAT = 0
	RL_SHADER_ATTRIB_VEC2
	RL_SHADER_ATTRIB_VEC3
	RL_SHADER_ATTRIB_VEC4
End Enum

Type rlFramebufferAttachType As Long
Enum
	RL_ATTACHMENT_COLOR_CHANNEL0 = 0
	RL_ATTACHMENT_COLOR_CHANNEL1 = 1
	RL_ATTACHMENT_COLOR_CHANNEL2 = 2
	RL_ATTACHMENT_COLOR_CHANNEL3 = 3
	RL_ATTACHMENT_COLOR_CHANNEL4 = 4
	RL_ATTACHMENT_COLOR_CHANNEL5 = 5
	RL_ATTACHMENT_COLOR_CHANNEL6 = 6
	RL_ATTACHMENT_COLOR_CHANNEL7 = 7
	RL_ATTACHMENT_DEPTH = 100
	RL_ATTACHMENT_STENCIL = 200
End Enum

Type rlFramebufferAttachTextureType As Long
Enum
	RL_ATTACHMENT_CUBEMAP_POSITIVE_X = 0
	RL_ATTACHMENT_CUBEMAP_NEGATIVE_X = 1
	RL_ATTACHMENT_CUBEMAP_POSITIVE_Y = 2
	RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y = 3
	RL_ATTACHMENT_CUBEMAP_POSITIVE_Z = 4
	RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z = 5
	RL_ATTACHMENT_TEXTURE2D = 100
	RL_ATTACHMENT_RENDERBUFFER = 200
End Enum

Type rlCullMode As Long
Enum
	RL_CULL_FACE_FRONT = 0
	RL_CULL_FACE_BACK
End Enum

Declare Sub rlMatrixMode(ByVal mode As Long)
Declare Sub rlPushMatrix()
Declare Sub rlPopMatrix()
Declare Sub rlLoadIdentity()
Declare Sub rlTranslatef(ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlRotatef(ByVal angle As Single, ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlScalef(ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlMultMatrixf(ByVal matf As Const Single Ptr)
Declare Sub rlFrustum(ByVal left As Double, ByVal right As Double, ByVal bottom As Double, ByVal top As Double, ByVal znear As Double, ByVal zfar As Double)
Declare Sub rlOrtho(ByVal left As Double, ByVal right As Double, ByVal bottom As Double, ByVal top As Double, ByVal znear As Double, ByVal zfar As Double)
Declare Sub rlViewport(ByVal x As Long, ByVal y As Long, ByVal width As Long, ByVal height As Long)
Declare Sub rlBegin(ByVal mode As Long)
Declare Sub rlEnd()
Declare Sub rlVertex2i(ByVal x As Long, ByVal y As Long)
Declare Sub rlVertex2f(ByVal x As Single, ByVal y As Single)
Declare Sub rlVertex3f(ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlTexCoord2f(ByVal x As Single, ByVal y As Single)
Declare Sub rlNormal3f(ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlColor4ub(ByVal r As UByte, ByVal g As UByte, ByVal b As UByte, ByVal a As UByte)
Declare Sub rlColor3f(ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub rlColor4f(ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal w As Single)
Declare Function rlEnableVertexArray(ByVal vaoId As ULong) As bool
Declare Sub rlDisableVertexArray()
Declare Sub rlEnableVertexBuffer(ByVal id As ULong)
Declare Sub rlDisableVertexBuffer()
declare sub rlEnableVertexBufferElement(byval id as ulong)
Declare Sub rlDisableVertexBufferElement()
Declare Sub rlEnableVertexAttribute(ByVal index As ULong)
Declare Sub rlDisableVertexAttribute(ByVal index As ULong)
Declare Sub rlActiveTextureSlot(ByVal slot As Long)
Declare Sub rlEnableTexture(ByVal id As ULong)
Declare Sub rlDisableTexture()
Declare Sub rlEnableTextureCubemap(ByVal id As ULong)
Declare Sub rlDisableTextureCubemap()
Declare Sub rlTextureParameters(ByVal id As ULong, ByVal param As Long, ByVal value As Long)
Declare Sub rlCubemapParameters(ByVal id As ULong, ByVal param As Long, ByVal value As Long)
Declare Sub rlEnableShader(ByVal id As ULong)
Declare Sub rlDisableShader()
Declare Sub rlEnableFramebuffer(ByVal id As ULong)
Declare Sub rlDisableFramebuffer()
Declare Sub rlActiveDrawBuffers(ByVal count As Long)
Declare Sub rlBlitFramebuffer(ByVal srcX As Long, ByVal srcY As Long, ByVal srcWidth As Long, ByVal srcHeight As Long, ByVal dstX As Long, ByVal dstY As Long, ByVal dstWidth As Long, ByVal dstHeight As Long, ByVal bufferMask As Long)
Declare Sub rlBindFramebuffer(ByVal target As ULong, ByVal framebuffer As ULong)
Declare Sub rlEnableColorBlend()
Declare Sub rlDisableColorBlend()
Declare Sub rlEnableDepthTest()
Declare Sub rlDisableDepthTest()
Declare Sub rlEnableDepthMask()
Declare Sub rlDisableDepthMask()
Declare Sub rlEnableBackfaceCulling()
Declare Sub rlDisableBackfaceCulling()
Declare Sub rlColorMask(ByVal r As bool, ByVal g As bool, ByVal b As bool, ByVal a As bool)
Declare Sub rlSetCullFace(ByVal mode As Long)
Declare Sub rlEnableScissorTest()
declare sub rlDisableScissorTest()
Declare Sub rlScissor(ByVal x As Long, ByVal y As Long, ByVal width As Long, ByVal height As Long)
Declare Sub rlEnableWireMode()
Declare Sub rlEnablePointMode()
Declare Sub rlDisableWireMode()
Declare Sub rlSetLineWidth(ByVal width As Single)
Declare Function rlGetLineWidth() As Single
Declare Sub rlEnableSmoothLines()
Declare Sub rlDisableSmoothLines()
Declare Sub rlEnableStereoRender()
Declare Sub rlDisableStereoRender()
Declare Function rlIsStereoRenderEnabled() As bool
Declare Sub rlClearColor(ByVal r As UByte, ByVal g As UByte, ByVal b As UByte, ByVal a As UByte)
Declare Sub rlClearScreenBuffers()
Declare Sub rlCheckErrors()
Declare Sub rlSetBlendMode(ByVal mode As Long)
Declare Sub rlSetBlendFactors(ByVal glSrcFactor As Long, ByVal glDstFactor As Long, ByVal glEquation As Long)
Declare Sub rlSetBlendFactorsSeparate(ByVal glSrcRGB As Long, ByVal glDstRGB As Long, ByVal glSrcAlpha As Long, ByVal glDstAlpha As Long, ByVal glEqRGB As Long, ByVal glEqAlpha As Long)
Declare Sub rlglInit(ByVal width As Long, ByVal height As Long)
Declare Sub rlglClose()
Declare Sub rlLoadExtensions(ByVal loader As Any Ptr)
Declare Function rlGetVersion() As Long
Declare Sub rlSetFramebufferWidth(ByVal width As Long)
Declare Function rlGetFramebufferWidth() As Long
Declare Sub rlSetFramebufferHeight(ByVal height As Long)
Declare Function rlGetFramebufferHeight() As Long
Declare Function rlGetTextureIdDefault() As ULong
Declare Function rlGetShaderIdDefault() As ULong
Declare Function rlGetShaderLocsDefault() As Long Ptr
declare function rlLoadRenderBatch(byval numBuffers as long, byval bufferElements as long) as rlRenderBatch
Declare Sub rlUnloadRenderBatch(ByVal batch As rlRenderBatch)
Declare Sub rlDrawRenderBatch(ByVal batch As rlRenderBatch Ptr)
Declare Sub rlSetRenderBatchActive(ByVal batch As rlRenderBatch Ptr)
Declare Sub rlDrawRenderBatchActive()
Declare Function rlCheckRenderBatchLimit(ByVal vCount As Long) As bool
Declare Sub rlSetTexture(ByVal id As ULong)
Declare Function rlLoadVertexArray() As ULong
Declare Function rlLoadVertexBuffer(ByVal buffer As Const Any Ptr, ByVal size As Long, ByVal dynamic As bool) As ULong
Declare Function rlLoadVertexBufferElement(ByVal buffer As Const Any Ptr, ByVal size As Long, ByVal dynamic As bool) As ULong
Declare Sub rlUpdateVertexBuffer(ByVal bufferId As ULong, ByVal data As Const Any Ptr, ByVal dataSize As Long, ByVal offset As Long)
Declare Sub rlUpdateVertexBufferElements(ByVal id As ULong, ByVal data As Const Any Ptr, ByVal dataSize As Long, ByVal offset As Long)
Declare Sub rlUnloadVertexArray(ByVal vaoId As ULong)
Declare Sub rlUnloadVertexBuffer(ByVal vboId As ULong)
Declare Sub rlSetVertexAttribute(ByVal index As ULong, ByVal compSize As Long, ByVal type As Long, ByVal normalized As bool, ByVal stride As Long, ByVal pointer As Const Any Ptr)
Declare Sub rlSetVertexAttributeDivisor(ByVal index As ULong, ByVal divisor As Long)
Declare Sub rlSetVertexAttributeDefault(ByVal locIndex As Long, ByVal value As Const Any Ptr, ByVal attribType As Long, ByVal count As Long)
Declare Sub rlDrawVertexArray(ByVal offset As Long, ByVal count As Long)
Declare Sub rlDrawVertexArrayElements(ByVal offset As Long, ByVal count As Long, ByVal buffer As Const Any Ptr)
Declare Sub rlDrawVertexArrayInstanced(ByVal offset As Long, ByVal count As Long, ByVal instances As Long)
Declare Sub rlDrawVertexArrayElementsInstanced(ByVal offset As Long, ByVal count As Long, ByVal buffer As Const Any Ptr, ByVal instances As Long)
Declare Function rlLoadTexture(ByVal data As Const Any Ptr, ByVal width As Long, ByVal height As Long, ByVal format As Long, ByVal mipmapCount As Long) As ULong
Declare Function rlLoadTextureDepth(ByVal width As Long, ByVal height As Long, ByVal useRenderBuffer As bool) As ULong
Declare Function rlLoadTextureCubemap(ByVal data As Const Any Ptr, ByVal size As Long, ByVal format As Long) As ULong
Declare Sub rlUpdateTexture(ByVal id As ULong, ByVal offsetX As Long, ByVal offsetY As Long, ByVal width As Long, ByVal height As Long, ByVal format As Long, ByVal data As Const Any Ptr)
Declare Sub rlGetGlTextureFormats(ByVal format As Long, ByVal glInternalFormat As ULong Ptr, ByVal glFormat As ULong Ptr, ByVal glType As ULong Ptr)
Declare Function rlGetPixelFormatName(ByVal format As ULong) As Const ZString Ptr
Declare Sub rlUnloadTexture(ByVal id As ULong)
Declare Sub rlGenTextureMipmaps(ByVal id As ULong, ByVal width As Long, ByVal height As Long, ByVal format As Long, ByVal mipmaps As Long Ptr)
declare function rlReadTexturePixels(byval id as ulong, byval width as long, byval height as long, byval format as long) as any ptr
Declare Function rlReadScreenPixels(ByVal width As Long, ByVal height As Long) As UByte Ptr
Declare Function rlLoadFramebuffer(ByVal width As Long, ByVal height As Long) As ULong
Declare Sub rlFramebufferAttach(ByVal fboId As ULong, ByVal texId As ULong, ByVal attachType As Long, ByVal texType As Long, ByVal mipLevel As Long)
Declare Function rlFramebufferComplete(ByVal id As ULong) As bool
Declare Sub rlUnloadFramebuffer(ByVal id As ULong)
Declare Function rlLoadShaderCode(ByVal vsCode As Const ZString Ptr, ByVal fsCode As Const ZString Ptr) As ULong
Declare Function rlCompileShader(ByVal shaderCode As Const ZString Ptr, ByVal type As Long) As ULong
declare function rlLoadShaderProgram(byval vShaderId as ulong, byval fShaderId as ulong) as ulong
declare sub rlUnloadShaderProgram(byval id as ulong)
declare function rlGetLocationUniform(byval shaderId as ulong, byval uniformName as const zstring ptr) as long
declare function rlGetLocationAttrib(byval shaderId as ulong, byval attribName as const zstring ptr) as long
Declare Sub rlSetUniform(ByVal locIndex As Long, ByVal value As Const Any Ptr, ByVal uniformType As Long, ByVal count As Long)
Declare Sub rlSetUniformMatrix(ByVal locIndex As Long, ByVal mat As Matrix)
Declare Sub rlSetUniformSampler(ByVal locIndex As Long, ByVal textureId As ULong)
Declare Sub rlSetShader(ByVal id As ULong, ByVal locs As Long Ptr)
Declare Function rlLoadComputeShaderProgram(ByVal shaderId As ULong) As ULong
Declare Sub rlComputeShaderDispatch(ByVal groupX As ULong, ByVal groupY As ULong, ByVal groupZ As ULong)
Declare Function rlLoadShaderBuffer(ByVal size As ULong, ByVal data As Const Any Ptr, ByVal usageHint As Long) As ULong
Declare Sub rlUnloadShaderBuffer(ByVal ssboId As ULong)
Declare Sub rlUpdateShaderBuffer(ByVal id As ULong, ByVal data As Const Any Ptr, ByVal dataSize As ULong, ByVal offset As ULong)
Declare Sub rlBindShaderBuffer(ByVal id As ULong, ByVal index As ULong)
Declare Sub rlReadShaderBuffer(ByVal id As ULong, ByVal dest As Any Ptr, ByVal count As ULong, ByVal offset As ULong)
Declare Sub rlCopyShaderBuffer(ByVal destId As ULong, ByVal srcId As ULong, ByVal destOffset As ULong, ByVal srcOffset As ULong, ByVal count As ULong)
Declare Function rlGetShaderBufferSize(ByVal id As ULong) As ULong
Declare Sub rlBindImageTexture(ByVal id As ULong, ByVal index As ULong, ByVal format As Long, ByVal readonly As bool)
Declare Function rlGetMatrixModelview() As Matrix
Declare Function rlGetMatrixProjection() As Matrix
Declare Function rlGetMatrixTransform() As Matrix
Declare Function rlGetMatrixProjectionStereo(ByVal eye As Long) As Matrix
Declare Function rlGetMatrixViewOffsetStereo(ByVal eye As Long) As Matrix
Declare Sub rlSetMatrixProjection(ByVal proj As Matrix)
Declare Sub rlSetMatrixModelview(ByVal view As Matrix)
Declare Sub rlSetMatrixProjectionStereo(ByVal right As Matrix, ByVal left As Matrix)
Declare Sub rlSetMatrixViewOffsetStereo(ByVal right As Matrix, ByVal left As Matrix)
Declare Sub rlLoadDrawCube()
Declare Sub rlLoadDrawQuad()

End Extern
