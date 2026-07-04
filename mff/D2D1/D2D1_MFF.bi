'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#include once "win/ole2.bi"
#include once "d2d1.bi"
#include once "dwrite.bi"
#include once "d2d1_1.bi"
#include once "dwrite_1.bi"
#include once "wincodec.bi"

#define COM_METHOD(p, i) Cast(Any Ptr Ptr, Cast(Any Ptr Ptr, p)[0])[i]

Type D3D10_FEATURE_LEVEL1 As Long
Enum
	D3D10_FEATURE_LEVEL_10_0   = &ha000
	D3D10_FEATURE_LEVEL_10_1   = &ha100
	D3D10_FEATURE_LEVEL_9_1    = &h9100
	D3D10_FEATURE_LEVEL_9_2    = &h9200
	D3D10_FEATURE_LEVEL_9_3    = &h9300
End Enum

Type D3D10_FEATURE_LEVEL1 As Long
Enum
	D3D10_FEATURE_LEVEL_10_0   = &ha000
	D3D10_FEATURE_LEVEL_10_1   = &ha100
	D3D10_FEATURE_LEVEL_9_1    = &h9100
	D3D10_FEATURE_LEVEL_9_2    = &h9200
	D3D10_FEATURE_LEVEL_9_3    = &h9300
End Enum

Type D2D1_WINDOW_STATE As Long
Enum
	D2D1_WINDOW_STATE_NONE       = &h0000000
	D2D1_WINDOW_STATE_OCCLUDED   = &h0000001
End Enum

Type IPrintDocumentPackageTargetVtbl
	' IUnknown
	QueryInterface As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef         As Function(ByVal this As Any Ptr) As ULong
	Release        As Function(ByVal this As Any Ptr) As ULong
	
	' IPrintDocumentPackageTarget
	GetPackageTargetTypes As Function(ByVal this As Any Ptr, ByRef targetCount As ULong, ByRef targetTypes As GUID Ptr) As HRESULT
	GetPackageTarget      As Function(ByVal this As Any Ptr, ByVal guidTargetType As Const GUID Ptr, ByRef ppPackageTarget As Any Ptr) As HRESULT
	Cancel                As Function(ByVal this As Any Ptr) As HRESULT
End Type

Type IPrintDocumentPackageTarget
	lpVtbl As IPrintDocumentPackageTargetVtbl Ptr
End Type

Type D2D1_PRINT_FONT_SUBSET_MODE As Long
Enum
	D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0
	D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1
	D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2
End Enum


Type DXGI_SAMPLE_DESC
	Count As ULong
	Quality As ULong
End Type

Type DXGI_SURFACE_DESC
	Width As ULong
	Height As ULong
	Format As DXGI_FORMAT
	SampleDesc As DXGI_SAMPLE_DESC
End Type

Type DXGI_RESIDENCY As Long
Enum
	DXGI_RESIDENCY_FULLY_RESIDENT = 1
	DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2
	DXGI_RESIDENCY_EVICTED_TO_DISK = 3
End Enum

Type DXGI_MAPPED_RECT
	Pitch As Long
	pBits As UByte Ptr
End Type

Type DXGI_RATIONAL
	Numerator   As ULong
	Denominator As ULong
End Type

Type DXGI_MODE_SCANLINE_ORDER As Long
Enum
	DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED = 0
	DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE = 1
	DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2
	DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3
End Enum

Type DXGI_MODE_SCALING As Long
Enum
	DXGI_MODE_SCALING_UNSPECIFIED = 0
	DXGI_MODE_SCALING_CENTERED     = 1
	DXGI_MODE_SCALING_STRETCHED    = 2
End Enum

Type DXGI_MODE_DESC
	Width As ULong
	Height As ULong
	RefreshRate As DXGI_RATIONAL
	Format As DXGI_FORMAT
	ScanlineOrdering As DXGI_MODE_SCANLINE_ORDER
	Scaling As DXGI_MODE_SCALING
End Type

Type DXGI_USAGE As Long
Enum
	DXGI_USAGE_SHADER_INPUT         = &h00000010
	DXGI_USAGE_RENDER_TARGET_OUTPUT = &h00000020
	DXGI_USAGE_BACK_BUFFER          = &h00000040
	DXGI_USAGE_DISCARD_ON_PRESENT   = &h00000080
	DXGI_USAGE_UNORDERED_ACCESS     = &h00000100
End Enum

Type DXGI_SWAP_EFFECT As Long
Enum
	DXGI_SWAP_EFFECT_DISCARD         = 0
	DXGI_SWAP_EFFECT_SEQUENTIAL      = 1
	DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL = 3
	DXGI_SWAP_EFFECT_FLIP_DISCARD    = 4
End Enum

Type DXGI_SWAP_CHAIN_DESC
	BufferDesc As DXGI_MODE_DESC
	SampleDesc As DXGI_SAMPLE_DESC
	BufferUsage As ULong
	BufferCount As ULong
	OutputWindow As HWND
	Windowed As BOOL
	SwapEffect As DXGI_SWAP_EFFECT
	Flags As ULong
End Type

Type DXGI_SCALING As Long
Enum
	DXGI_SCALING_STRETCH = 0
	DXGI_SCALING_NONE = 1
	DXGI_SCALING_ASPECT_RATIO_STRETCH = 2
End Enum

Type DXGI_ALPHA_MODE As Long
Enum
	DXGI_ALPHA_MODE_UNSPECIFIED     = 0
	DXGI_ALPHA_MODE_PREMULTIPLIED   = 1
	DXGI_ALPHA_MODE_STRAIGHT        = 2
	DXGI_ALPHA_MODE_IGNORE          = 3
	DXGI_ALPHA_MODE_FORCE_DWORD     = &hFFFFFFFF
End Enum

Type DXGI_SWAP_CHAIN_DESC1
	Width As UINT
	Height As UINT
	Format As DXGI_FORMAT
	Stereo As BOOL
	SampleDesc As DXGI_SAMPLE_DESC
	BufferUsage As DXGI_USAGE
	BufferCount As UINT
	Scaling As DXGI_SCALING
	SwapEffect As DXGI_SWAP_EFFECT
	AlphaMode As DXGI_ALPHA_MODE
	Flags As UInteger
End Type

Type IDXGISurfaceVtbl
	' IUnknown
	QueryInterface As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef         As Function(ByVal this As Any Ptr) As ULong
	Release        As Function(ByVal this As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData           As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByVal dataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface  As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByVal pUnknown As Any Ptr) As HRESULT
	GetPrivateData           As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByRef dataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	GetParent                As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppParent As Any Ptr Ptr) As HRESULT
	GetDevice                As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppDevice As Any Ptr Ptr) As HRESULT
	
	' IDXGISurface
	GetDesc                  As Function(ByVal this As Any Ptr, ByVal pDesc As DXGI_SURFACE_DESC Ptr) As HRESULT
	Map                      As Function(ByVal this As Any Ptr, ByVal pLockedRect As DXGI_MAPPED_RECT Ptr, ByVal MapFlags As ULong) As HRESULT
	Unmap                    As Function(ByVal this As Any Ptr) As HRESULT
End Type

Type IDXGISurface
	lpVtbl As IDXGISurfaceVtbl Ptr
End Type

Type D3D11_RESOURCE_DIMENSION As Long
Enum
	D3D11_RESOURCE_DIMENSION_UNKNOWN    = 0
	D3D11_RESOURCE_DIMENSION_BUFFER     = 1
	D3D11_RESOURCE_DIMENSION_TEXTURE1D  = 2
	D3D11_RESOURCE_DIMENSION_TEXTURE2D  = 3
	D3D11_RESOURCE_DIMENSION_TEXTURE3D  = 4
End Enum

Type D3D11_TEXTURE2D_DESC
	Width              As ULong
	Height             As ULong
	MipLevels          As ULong
	ArraySize          As ULong
	Format             As ULong            ' DXGI_FORMAT
	SampleDesc_Count   As ULong
	SampleDesc_Quality As ULong
	Usage              As ULong            ' D3D11_USAGE
	BindFlags          As ULong
	CPUAccessFlags     As ULong
	MiscFlags          As ULong
End Type

Dim Shared IID_ID3D11Texture2D As GUID = Type<GUID>(&h6F15AAF2, &hD208, &h4E89, {&h9A, &hB4, &h48, &h95, &h85, &h37, &hCD, &h3E})

Type ID3D11Texture2DVtbl
	' IUnknown
	QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef             As Function(ByVal This As Any Ptr) As ULong
	Release            As Function(ByVal This As Any Ptr) As ULong
	
	' ID3D11DeviceChild
	GetDevice          As Sub(ByVal This As Any Ptr, ByVal ppDevice As Any Ptr Ptr)
	GetPrivateData     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As ULong Ptr, ByVal pData As Any Ptr) As HRESULT
	SetPrivateData     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT
	
	' ID3D11Resource
	GetType_           As Sub(ByVal This As Any Ptr, ByVal pResourceDimension As D3D11_RESOURCE_DIMENSION)
	SetEvictionPriority As Sub(ByVal This As Any Ptr, ByVal EvictionPriority As ULong)
	GetEvictionPriority As Function(ByVal This As Any Ptr) As ULong
	
	' ID3D11Texture2D
	GetDesc            As Sub(ByVal This As Any Ptr, ByVal pDesc As D3D11_TEXTURE2D_DESC Ptr)
End Type

Type ID3D11Texture2D
	lpVtbl As ID3D11Texture2DVtbl Ptr
End Type

'Dim Shared IID_IDXGISurface As GUID = Type<GUID>(&hCB1193DB, &h6C49, &h4D86, {&hBF, &h47, &h9E, &h23, &hBB, &hD2, &h60, &hEC})

Dim Shared IID_IDXGISurface As GUID = Type<GUID>(&hcafcb56c, &h6ac3, &h4889, {&hbf, &h47, &h9e, &h23, &hbb, &hd2, &h60, &hec})

Dim Shared IID_IDXGISurface1 As GUID = Type<GUID>(&h4AE63092, &h6327, &h4C1B, {&h80, &hAE, &hBF, &hE1, &h2E, &hA3, &h2B, &h86})

Type DXGI_ADAPTER_DESC
	Description     As WString * 128
	VendorId        As ULong
	DeviceId        As ULong
	SubSysId        As ULong
	Revision        As ULong
	DedicatedVideoMemory As ULONGLONG
	DedicatedSystemMemory As ULONGLONG
	SharedSystemMemory    As ULONGLONG
	AdapterLuid      As LUID
End Type

Type IDXGIAdapterVtbl
	' IUnknown
	QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef             As Function(ByVal This As Any Ptr) As ULong
	Release            As Function(ByVal This As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal pUnknown As Any Ptr) As HRESULT
	GetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
	GetParent          As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIAdapter
	EnumOutputs        As Function(ByVal This As Any Ptr, ByVal Output As UInteger, ByVal ppOutput As Any Ptr Ptr) As HRESULT
	GetDesc            As Function(ByVal This As Any Ptr, ByVal pDesc As DXGI_ADAPTER_DESC Ptr) As HRESULT
	CheckInterfaceSupport As Function(ByVal This As Any Ptr, ByVal InterfaceName As Const GUID Ptr, ByVal pUMDVersion As LARGE_INTEGER Ptr) As HRESULT
End Type

Type IDXGIAdapter
	lpVtbl As IDXGIAdapterVtbl Ptr
End Type

Type IDXGIDeviceVtbl
	' IUnknown
	QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef             As Function(ByVal This As Any Ptr) As ULong
	Release            As Function(ByVal This As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef pDataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	GetParent          As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIDevice
	GetAdapter                  As Function(ByVal This As Any Ptr, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT
	CreateSurface               As Function(ByVal This As Any Ptr, ByVal pDesc As DXGI_SURFACE_DESC Ptr, ByVal SurfaceCount As ULong, ByVal Usage As ULong, ByVal pSharedResource As Any Ptr, ByVal ppSurface As IDXGISurface Ptr Ptr) As HRESULT
	QueryResourceResidency      As Function(ByVal This As Any Ptr, ByVal ppResources As IUnknown Ptr Ptr, ByVal pResidencyStatus As DXGI_RESIDENCY, ByVal ResourceCount As ULong) As HRESULT
	SetGPUThreadPriority        As Function(ByVal This As Any Ptr, ByVal Priority As Long) As HRESULT
	GetGPUThreadPriority        As Function(ByVal This As Any Ptr, ByVal pPriority As Long Ptr) As HRESULT
End Type

Type IDXGIDevice
	lpVtbl As IDXGIDeviceVtbl Ptr
End Type

Dim Shared IID_IDXGIDevice As GUID = Type<GUID>(&h54ec77fa, &h1377, &h44e6, {&h8c, &h32, &h88, &hfd, &h5f, &h44, &hc8, &h4c})

Type DXGI_MODE_ROTATION As Long
Enum
	DXGI_MODE_ROTATION_UNSPECIFIED = 0,
	DXGI_MODE_ROTATION_IDENTITY = 1,
	DXGI_MODE_ROTATION_ROTATE90 = 2,
	DXGI_MODE_ROTATION_ROTATE180 = 3,
	DXGI_MODE_ROTATION_ROTATE270 = 4
End Enum

Type DXGI_OUTPUT_DESC
	DeviceName As WCHAR Ptr
	DesktopCoordinates As RECT
	AttachedToDesktop As BOOL
	Rotation As DXGI_MODE_ROTATION
	Monitor As HMONITOR
End Type

Type DXGI_RGB
	Red   As Single
	Green As Single
	Blue  As Single
End Type

Type DXGI_GAMMA_CONTROL_CAPABILITIES
	ScaleAndOffsetSupported As BOOL
	MaxConvertedValue       As Single
	MinConvertedValue       As Single
	NumGammaControlPoints   As ULong
	ControlPointPositions   As Single Ptr
End Type

Type DXGI_GAMMA_CONTROL
	Scale   As DXGI_RGB                  ' Масштаб по каждому каналу (умножение)
	Offset  As DXGI_RGB                  ' Смещение по каждому каналу (прибавление)
	GammaCurve(0 To 1024) As DXGI_RGB   ' Контрольные точки гамма-кривой (обычно 1025 точек)
End Type

Type DXGI_FRAME_STATISTICS
	PresentCount As ULong
	PresentRefreshCount As ULong
	SyncRefreshCount As ULong
	SyncQPCTime As LongInt
	SyncGPUTime As LongInt
End Type


Type IDXGIOutput As IDXGIOutput_

Type IDXGIOutputVtbl
	' IUnknown
	QueryInterface As Function(This As IDXGIOutput Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
	AddRef As Function(This As IDXGIOutput Ptr) As ULong
	Release As Function(This As IDXGIOutput Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, dataSize As ULong, data As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, pDataSize As ULong Ptr, data As Any Ptr) As HRESULT
	GetParent As Function(This As IDXGIOutput Ptr, riid As Const GUID Ptr, ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIOutput
	GetDesc As Function(This As IDXGIOutput Ptr, desc As DXGI_OUTPUT_DESC Ptr) As HRESULT
	GetDisplayModeList As Function(This As IDXGIOutput Ptr, format As DXGI_FORMAT, flags As ULong, numModes As ULong Ptr, desc As DXGI_MODE_DESC Ptr) As HRESULT
	FindClosestMatchingMode As Function(This As IDXGIOutput Ptr, modeToMatch As Const DXGI_MODE_DESC Ptr, closestMatch As DXGI_MODE_DESC Ptr, concernedDevice As IUnknown Ptr) As HRESULT
	WaitForVBlank As Function(This As IDXGIOutput Ptr) As HRESULT
	TakeOwnership As Function(This As IDXGIOutput Ptr, device As IUnknown Ptr, exclusive As BOOL) As HRESULT
	ReleaseOwnership As Sub(This As IDXGIOutput Ptr)
	GetGammaControlCapabilities As Function(This As IDXGIOutput Ptr, caps As DXGI_GAMMA_CONTROL_CAPABILITIES Ptr) As HRESULT
	SetGammaControl As Function(This As IDXGIOutput Ptr, gammaControl As Const DXGI_GAMMA_CONTROL Ptr) As HRESULT
	GetGammaControl As Function(This As IDXGIOutput Ptr, gammaControl As DXGI_GAMMA_CONTROL Ptr) As HRESULT
	SetDisplaySurface As Function(This As IDXGIOutput Ptr, scanoutSurface As IDXGISurface Ptr) As HRESULT
	GetDisplaySurfaceData As Function(This As IDXGIOutput Ptr, destination As IDXGISurface Ptr) As HRESULT
	GetFrameStatistics As Function(This As IDXGIOutput Ptr, stats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
End Type

Type IDXGIOutput_
	lpVtbl As IDXGIOutputVtbl Ptr
End Type

Type IDXGISwapChain As IDXGISwapChain_

Type IDXGISwapChainVtbl
	' IUnknown
	QueryInterface As Function(This As IDXGISwapChain Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef As Function(This As IDXGISwapChain Ptr) As ULong
	Release As Function(This As IDXGISwapChain Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, size As ULong, data As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, pSize As ULong Ptr, data As Any Ptr) As HRESULT
	GetParent As Function(This As IDXGISwapChain Ptr, riid As Const GUID Ptr, ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGISwapChain
	Present As Function(This As IDXGISwapChain Ptr, syncInterval As ULong, flags As ULong) As HRESULT
	GetBuffer As Function(This As IDXGISwapChain Ptr, bufferIndex As UINT, riid As Const GUID Ptr, surface As IDXGISurface Ptr Ptr) As HRESULT
	SetFullscreenState As Function(This As IDXGISwapChain Ptr, fullscreen As BOOL, target As IDXGIOutput Ptr) As HRESULT
	GetFullscreenState As Function(This As IDXGISwapChain Ptr, fullscreen As BOOL Ptr, target As IDXGIOutput Ptr Ptr) As HRESULT
	GetDesc As Function(This As IDXGISwapChain Ptr, desc As DXGI_SWAP_CHAIN_DESC Ptr) As HRESULT
	ResizeBuffers As Function(This As IDXGISwapChain Ptr, bufferCount As ULong, width As ULong, height As ULong, format As DXGI_FORMAT, flags As ULong) As HRESULT
	ResizeTarget As Function(This As IDXGISwapChain Ptr, pNewTargetParameters As Const DXGI_MODE_DESC Ptr) As HRESULT
	GetContainingOutput As Function(This As IDXGISwapChain Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
	GetFrameStatistics As Function(This As IDXGISwapChain Ptr, stats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
	GetLastPresentCount As Function(This As IDXGISwapChain Ptr, pLastPresentCount As ULong Ptr) As HRESULT
End Type

Type IDXGISwapChain_
	lpVtbl As IDXGISwapChainVtbl Ptr
End Type

Dim Shared IID_IDXGIFactory As GUID = Type<GUID>(&h7B7166EC, &h21C7, &h44AE, {&hB2, &h1A, &hC9, &hAE, &h32, &h1A, &hE3, &h69})

Type IDXGIFactory As IDXGIFactory_

Type IDXGIFactoryVtbl
	' IUnknown
	QueryInterface As Function(This As IDXGIFactory Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
	AddRef As Function(This As IDXGIFactory Ptr) As ULong
	Release As Function(This As IDXGIFactory Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, dataSize As ULong, data As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, unknown As IUnknown Ptr) As HRESULT
	GetPrivateData As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, dataSize As ULong Ptr, data As Any Ptr) As HRESULT
	GetParent As Function(This As IDXGIFactory Ptr, riid As Const GUID Ptr, parent As Any Ptr Ptr) As HRESULT
	
	' IDXGIFactory
	EnumAdapters As Function(This As IDXGIFactory Ptr, adapterIndex As ULong, adapter As IDXGIAdapter Ptr Ptr) As HRESULT
	MakeWindowAssociation As Function(This As IDXGIFactory Ptr, windowHandle As HWND, flags As ULong) As HRESULT
	GetWindowAssociation As Function(This As IDXGIFactory Ptr, windowHandle As HWND Ptr) As HRESULT
	CreateSwapChain As Function(ByVal This As IDXGIFactory Ptr, ByVal device As IUnknown Ptr, ByVal desc As Const DXGI_SWAP_CHAIN_DESC Ptr, ByVal swapChain As IDXGISwapChain Ptr Ptr) As HRESULT
	CreateSoftwareAdapter As Function(This As IDXGIFactory Ptr, moduleHandle As HMODULE, adapter As IDXGIAdapter Ptr Ptr) As HRESULT
End Type

Type IDXGIFactory_
	lpVtbl As IDXGIFactoryVtbl Ptr
End Type

Type D3D_FEATURE_LEVEL As Long
Enum
	D3D_FEATURE_LEVEL_9_1  = &h9100
	D3D_FEATURE_LEVEL_9_2  = &h9200
	D3D_FEATURE_LEVEL_9_3  = &h9300
	D3D_FEATURE_LEVEL_10_0 = &ha000
	D3D_FEATURE_LEVEL_10_1 = &ha100
	D3D_FEATURE_LEVEL_11_0 = &hb000
	D3D_FEATURE_LEVEL_11_1 = &hb100
	D3D_FEATURE_LEVEL_12_0 = &hc000
	D3D_FEATURE_LEVEL_12_1 = &hc100
End Enum

Type D3D_DRIVER_TYPE As Long
Enum
	D3D_DRIVER_TYPE_UNKNOWN           = 0
	D3D_DRIVER_TYPE_HARDWARE          = 1
	D3D_DRIVER_TYPE_REFERENCE         = 2
	D3D_DRIVER_TYPE_NULL              = 3
	D3D_DRIVER_TYPE_SOFTWARE          = 4
	D3D_DRIVER_TYPE_WARP              = 5
End Enum

Type ID3D11DeviceVtbl
	' IUnknown
	QueryInterface              As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef                      As Function(ByVal This As Any Ptr) As ULong
	Release                     As Function(ByVal This As Any Ptr) As ULong
	
	' ID3D11Device
	CreateBuffer                As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppBuffer As Any Ptr Ptr) As HRESULT
	CreateTexture1D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture1D As Any Ptr Ptr) As HRESULT
	CreateTexture2D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture2D As Any Ptr Ptr) As HRESULT
	CreateTexture3D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture3D As Any Ptr Ptr) As HRESULT
	CreateShaderResourceView    As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppSRView As Any Ptr Ptr) As HRESULT
	CreateUnorderedAccessView   As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppUAView As Any Ptr Ptr) As HRESULT
	CreateRenderTargetView      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppRTView As Any Ptr Ptr) As HRESULT
	CreateDepthStencilView      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppDSView As Any Ptr Ptr) As HRESULT
	CreateInputLayout           As Function(ByVal This As Any Ptr, ByVal pInputElementDescs As Any Ptr, ByVal NumElements As UInteger, ByVal pShaderBytecodeWithInputSignature As Any Ptr, ByVal BytecodeLength As UInteger, ByVal ppInputLayout As Any Ptr Ptr) As HRESULT
	CreateVertexShader          As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppVertexShader As Any Ptr Ptr) As HRESULT
	CreateGeometryShader        As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppGeometryShader As Any Ptr Ptr) As HRESULT
	CreatePixelShader           As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppPixelShader As Any Ptr Ptr) As HRESULT
	CreateHullShader            As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppHullShader As Any Ptr Ptr) As HRESULT
	CreateDomainShader          As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppDomainShader As Any Ptr Ptr) As HRESULT
	CreateComputeShader         As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppComputeShader As Any Ptr Ptr) As HRESULT
	CreateClassLinkage          As Function(ByVal This As Any Ptr, ByVal ppLinkage As Any Ptr Ptr) As HRESULT
	CreateBlendState            As Function(ByVal This As Any Ptr, ByVal pBlendStateDesc As Any Ptr, ByVal ppBlendState As Any Ptr Ptr) As HRESULT
	CreateDepthStencilState     As Function(ByVal This As Any Ptr, ByVal pDepthStencilDesc As Any Ptr, ByVal ppDepthStencilState As Any Ptr Ptr) As HRESULT
	CreateRasterizerState       As Function(ByVal This As Any Ptr, ByVal pRasterizerDesc As Any Ptr, ByVal ppRasterizerState As Any Ptr Ptr) As HRESULT
	CreateSamplerState          As Function(ByVal This As Any Ptr, ByVal pSamplerDesc As Any Ptr, ByVal ppSamplerState As Any Ptr Ptr) As HRESULT
	CreateQuery                 As Function(ByVal This As Any Ptr, ByVal pQueryDesc As Any Ptr, ByVal ppQuery As Any Ptr Ptr) As HRESULT
	CreatePredicate             As Function(ByVal This As Any Ptr, ByVal pPredicateDesc As Any Ptr, ByVal ppPredicate As Any Ptr Ptr) As HRESULT
	CreateCounter               As Function(ByVal This As Any Ptr, ByVal pCounterDesc As Any Ptr, ByVal ppCounter As Any Ptr Ptr) As HRESULT
	CreateDeferredContext       As Function(ByVal This As Any Ptr, ByVal ContextFlags As UInteger, ByVal ppDeferredContext As Any Ptr Ptr) As HRESULT
	OpenSharedResource          As Function(ByVal This As Any Ptr, ByVal hResource As HANDLE, ByVal riid As Const GUID Ptr, ByVal ppResource As Any Ptr Ptr) As HRESULT
	CheckFormatSupport          As Function(ByVal This As Any Ptr, ByVal Format As UInteger, ByVal pFormatSupport As UInteger Ptr) As HRESULT
	CheckMultisampleQualityLevels As Function(ByVal This As Any Ptr, ByVal Format As UInteger, ByVal SampleCount As UInteger, ByVal pNumQualityLevels As UInteger Ptr) As HRESULT
	CheckCounterInfo            As Sub     (ByVal This As Any Ptr, ByVal pCounterInfo As Any Ptr)
	CheckCounter                As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pType As Any Ptr, ByVal pActiveCounters As UInteger Ptr, ByVal szName As ZString Ptr, ByVal pNameLength As UInteger Ptr, ByVal szUnits As ZString Ptr, ByVal pUnitsLength As UInteger Ptr, ByVal szDesc As ZString Ptr, ByVal pDescLength As UInteger Ptr) As HRESULT
	CheckFeatureSupport         As Function(ByVal This As Any Ptr, ByVal Feature As UInteger, ByVal pFeatureSupportData As Any Ptr, ByVal FeatureSupportDataSize As UInteger) As HRESULT
	GetPrivateData              As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
	SetPrivateData              As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
	SetPrivateDataInterface     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT
	GetFeatureLevel             As Function(ByVal This As Any Ptr) As UInteger
	GetCreationFlags            As Function(ByVal This As Any Ptr) As UInteger
	GetDeviceRemovedReason      As Function(ByVal This As Any Ptr) As HRESULT
	GetImmediateContext         As Sub     (ByVal This As Any Ptr, ByVal ppImmediateContext As Any Ptr Ptr)
	SetExceptionMode            As Function(ByVal This As Any Ptr, ByVal RaiseFlags As UInteger) As HRESULT
	GetExceptionMode            As Function(ByVal This As Any Ptr) As UInteger
End Type

Type ID3D11Device
	lpVtbl As ID3D11DeviceVtbl Ptr
End Type

Type ID3D11DeviceContextVtbl
	' IUnknown
	QueryInterface           As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(ByVal This As Any Ptr) As ULong
	Release                  As Function(ByVal This As Any Ptr) As ULong
	
	' ID3D11DeviceChild
	GetDevice                As Sub(ByVal This As Any Ptr, ByVal ppDevice As Any Ptr Ptr)
	GetPrivateData           As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
	SetPrivateData           As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
	SetPrivateDataInterface  As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT
	
	' ID3D11DeviceContext
	VSSetConstantBuffers     As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	PSSetShaderResources     As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	PSSetShader              As Sub(ByVal This As Any Ptr, ByVal pPixelShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	PSSetSamplers            As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	VSSetShader              As Sub(ByVal This As Any Ptr, ByVal pVertexShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	DrawIndexed              As Sub(ByVal This As Any Ptr, ByVal IndexCount As UInteger, ByVal StartIndexLocation As UInteger, ByVal BaseVertexLocation As Integer)
	Draw                     As Sub(ByVal This As Any Ptr, ByVal VertexCount As UInteger, ByVal StartVertexLocation As UInteger)
	Map                      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal Subresource As UInteger, ByVal MapType As UInteger, ByVal MapFlags As UInteger, ByVal pMappedResource As Any Ptr) As HRESULT
	Unmap                    As Sub(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal Subresource As UInteger)
	PSSetConstantBuffers         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	IASetInputLayout             As Sub(ByVal This As Any Ptr, ByVal pInputLayout As Any Ptr)
	IASetVertexBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppVertexBuffers As Any Ptr Ptr, ByVal pStrides As UInteger Ptr, ByVal pOffsets As UInteger Ptr)
	IASetIndexBuffer             As Sub(ByVal This As Any Ptr, ByVal pIndexBuffer As Any Ptr, ByVal Format As UInteger, ByVal Offset As UInteger)
	DrawIndexedInstanced         As Sub(ByVal This As Any Ptr, ByVal IndexCountPerInstance As UInteger, ByVal InstanceCount As UInteger, ByVal StartIndexLocation As UInteger, ByVal BaseVertexLocation As Integer, ByVal StartInstanceLocation As UInteger)
	DrawInstanced                As Sub(ByVal This As Any Ptr, ByVal VertexCountPerInstance As UInteger, ByVal InstanceCount As UInteger, ByVal StartVertexLocation As UInteger, ByVal StartInstanceLocation As UInteger)
	GSSetConstantBuffers         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	GSSetShader                  As Sub(ByVal This As Any Ptr, ByVal pShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	IASetPrimitiveTopology       As Sub(ByVal This As Any Ptr, ByVal Topology As UInteger)
	VSSetShaderResources         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	VSSetSamplers                As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	Begin_                      As Sub(ByVal This As Any Ptr, ByVal pAsync As Any Ptr)
	End_                        As Sub(ByVal This As Any Ptr, ByVal pAsync As Any Ptr)
	GetData                     As Function(ByVal This As Any Ptr, ByVal pAsync As Any Ptr, ByVal pData As Any Ptr, ByVal DataSize As UInteger, ByVal GetDataFlags As UInteger) As HRESULT
	SetPredication               As Sub(ByVal This As Any Ptr, ByVal pPredicate As Any Ptr, ByVal PredicateValue As BOOL)
	GSSetShaderResources         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	GSSetSamplers                As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	OMSetRenderTargets           As Sub(ByVal This As Any Ptr, ByVal NumViews As UInteger, ByVal ppRenderTargetViews As Any Ptr Ptr, ByVal pDepthStencilView As Any Ptr)
	OMSetRenderTargetsAndUnorderedAccessViews As Sub(ByVal This As Any Ptr, ByVal NumRTVs As UInteger, ByVal ppRTVs As Any Ptr Ptr, ByVal pDSV As Any Ptr, ByVal UAVStartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUAVs As Any Ptr Ptr, ByVal pUAVInitialCounts As UInteger Ptr)
	OMSetBlendState              As Sub(ByVal This As Any Ptr, ByVal pBlendState As Any Ptr, ByVal BlendFactor As Single Ptr, ByVal SampleMask As UInteger)
	OMSetDepthStencilState       As Sub(ByVal This As Any Ptr, ByVal pDepthStencilState As Any Ptr, ByVal StencilRef As UInteger)
	SOSetTargets                 As Sub(ByVal This As Any Ptr, ByVal NumBuffers As UInteger, ByVal ppSOTargets As Any Ptr Ptr, ByVal pOffsets As UInteger Ptr)
	DrawAuto                     As Sub(ByVal This As Any Ptr)
	DrawIndexedInstancedIndirect As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
	DrawInstancedIndirect         As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
	Dispatch                      As Sub(ByVal This As Any Ptr, ByVal ThreadGroupCountX As UInteger, ByVal ThreadGroupCountY As UInteger, ByVal ThreadGroupCountZ As UInteger)
	DispatchIndirect               As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
	RSSetState                      As Sub(ByVal This As Any Ptr, ByVal pRasterizerState As Any Ptr)
	RSSetViewports                  As Sub(ByVal This As Any Ptr, ByVal NumViewports As UInteger, ByVal pViewports As Any Ptr)
	RSSetScissorRects               As Sub(ByVal This As Any Ptr, ByVal NumRects As UInteger, ByVal pRects As Any Ptr)
	CopySubresourceRegion          As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal DstX As UInteger, ByVal DstY As UInteger, ByVal DstZ As UInteger, ByVal pSrcResource As Any Ptr, ByVal SrcSubresource As UInteger, ByVal pSrcBox As Any Ptr)
	CopyResource                   As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal pSrcResource As Any Ptr)
	UpdateSubresource              As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal pDstBox As Any Ptr, ByVal pSrcData As Any Ptr, ByVal SrcRowPitch As UInteger, ByVal SrcDepthPitch As UInteger)
	CopyStructureCount             As Sub(ByVal This As Any Ptr, ByVal pDstBuffer As Any Ptr, ByVal DstAlignedByteOffset As UInteger, ByVal pSrcView As Any Ptr)
	ClearRenderTargetView          As Sub(ByVal This As Any Ptr, ByVal pRenderTargetView As Any Ptr, ByVal ColorRGBA As Single Ptr)
	ClearUnorderedAccessViewUint   As Sub(ByVal This As Any Ptr, ByVal pUnorderedAccessView As Any Ptr, ByVal Values As UInteger Ptr)
	ClearUnorderedAccessViewFloat  As Sub(ByVal This As Any Ptr, ByVal pUnorderedAccessView As Any Ptr, ByVal Values As Single Ptr)
	ClearDepthStencilView          As Sub(ByVal This As Any Ptr, ByVal pDepthStencilView As Any Ptr, ByVal ClearFlags As UInteger, ByVal Depth As Single, ByVal Stencil As UByte)
	GenerateMips                   As Sub(ByVal This As Any Ptr, ByVal pShaderResourceView As Any Ptr)
	SetResourceMinLOD              As Sub(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal MinLOD As Single)
	GetResourceMinLOD              As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr) As Single
	ResolveSubresource             As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal pSrcResource As Any Ptr, ByVal SrcSubresource As UInteger, ByVal Format As UInteger)
	ExecuteCommandList             As Sub(ByVal This As Any Ptr, ByVal pCommandList As Any Ptr, ByVal RestoreContextState As BOOL)
	HSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	HSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pHullShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	HSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	HSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	DSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	DSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pDomainShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	DSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	DSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	CSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	CSSetUnorderedAccessViews      As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUnorderedAccessViews As Any Ptr Ptr, ByVal pUAVInitialCounts As UInteger Ptr)
	CSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pComputeShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
	CSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	CSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	VSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	PSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	PSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppPixelShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	PSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	VSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppVertexShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	PSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	IAGetInputLayout               As Sub(ByVal This As Any Ptr, ByVal ppInputLayout As Any Ptr Ptr)
	IAGetVertexBuffers             As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppVertexBuffers As Any Ptr Ptr, ByVal pStrides As UInteger Ptr, ByVal pOffsets As UInteger Ptr)
	IAGetIndexBuffer               As Sub(ByVal This As Any Ptr, ByVal ppIndexBuffer As Any Ptr Ptr, ByVal pFormat As UInteger Ptr, ByVal pOffset As UInteger Ptr)
	GSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	GSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppGeometryShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	IAGetPrimitiveTopology         As Sub(ByVal This As Any Ptr, ByVal pTopology As UInteger Ptr)
	VSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	VSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	GetPredication                 As Sub(ByVal This As Any Ptr, ByVal ppPredicate As Any Ptr Ptr, ByVal pPredicateValue As BOOL Ptr)
	GSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	GSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	OMGetRenderTargets             As Sub(ByVal This As Any Ptr, ByVal NumViews As UInteger, ByVal ppRenderTargetViews As Any Ptr Ptr, ByVal ppDepthStencilView As Any Ptr Ptr)
	OMGetRenderTargetsAndUnorderedAccessViews As Sub(ByVal This As Any Ptr, ByVal NumRTVs As UInteger, ByVal ppRTVs As Any Ptr Ptr, ByVal ppDSV As Any Ptr Ptr, ByVal UAVStartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUAVs As Any Ptr Ptr)
	OMGetBlendState                As Sub(ByVal This As Any Ptr, ByVal ppBlendState As Any Ptr Ptr, ByVal BlendFactor As Single Ptr, ByVal pSampleMask As UInteger Ptr)
	OMGetDepthStencilState         As Sub(ByVal This As Any Ptr, ByVal ppDepthStencilState As Any Ptr Ptr, ByVal pStencilRef As UInteger Ptr)
	SOGetTargets                   As Sub(ByVal This As Any Ptr, ByVal NumBuffers As UInteger, ByVal ppSOTargets As Any Ptr Ptr)
	RSGetState                     As Sub(ByVal This As Any Ptr, ByVal ppRasterizerState As Any Ptr Ptr)
	RSGetViewports                 As Sub(ByVal This As Any Ptr, ByVal pNumViewports As UInteger Ptr, ByVal pViewports As Any Ptr)
	RSGetScissorRects              As Sub(ByVal This As Any Ptr, ByVal pNumRects As UInteger Ptr, ByVal pRects As Any Ptr)
	HSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	HSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppHullShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	HSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	HSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	DSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	DSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppDomainShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	DSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	DSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	CSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
	CSGetUnorderedAccessViews      As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUnorderedAccessViews As Any Ptr Ptr)
	CSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppComputeShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
	CSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
	CSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
	ClearState                     As Sub(ByVal This As Any Ptr)
	Flush                          As Sub(ByVal This As Any Ptr)
	GetType_                       As Sub(ByVal This As Any Ptr, ByVal pType As UInteger Ptr)
	GetContextFlags                As Sub(ByVal This As Any Ptr, ByVal pFlags As UInteger Ptr)
	FinishCommandList              As Function(ByVal This As Any Ptr, ByVal RestoreDeferredContextState As BOOL, ByVal ppCommandList As Any Ptr Ptr) As HRESULT
End Type

Type ID3D11DeviceContext
	lpVtbl As ID3D11DeviceContextVtbl Ptr
End Type

Dim Shared IID_IDXGIFactory2 As GUID = (&h50C83A1C, &hE072, &h4C48, {&h87, &hB0, &h36, &h30, &hFA, &h36, &hA6, &hD0})

Type DXGI_SWAP_CHAIN_FULLSCREEN_DESC
	RefreshRate       As DXGI_RATIONAL
	ScanlineOrdering  As DXGI_MODE_SCANLINE_ORDER
	Scaling           As DXGI_MODE_SCALING
	Windowed          As BOOL
End Type

Type DXGI_ADAPTER_DESC1
	Description(127) As WCHAR       ' WCHAR[128] = 256 bytes
	VendorId As UInteger
	DeviceId As UInteger
	SubSysId As UInteger
	Revision As UInteger
	DedicatedVideoMemory As ULongInt
	DedicatedSystemMemory As ULongInt
	SharedSystemMemory As ULongInt
	AdapterLuid As LUID
	Flags As UInteger
End Type

Type IDXGIAdapter1Vtbl
	' IUnknown
	QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef         As Function(ByVal This As Any Ptr) As ULong
	Release        As Function(ByVal This As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData          As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData          As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
	GetParent               As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIAdapter
	EnumOutputs             As Function(ByVal This As Any Ptr, ByVal Output As UINT, ByVal ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
	GetDesc                 As Function(ByVal This As Any Ptr, ByRef pDesc As DXGI_ADAPTER_DESC) As HRESULT
	CheckInterfaceSupport   As Function(ByVal This As Any Ptr, ByVal InterfaceName As REFGUID, ByRef pUMDVersion As LARGE_INTEGER) As HRESULT
	
	' IDXGIAdapter1
	GetDesc1                As Function(ByVal This As Any Ptr, ByRef pDesc As DXGI_ADAPTER_DESC1) As HRESULT
End Type

Type IDXGIAdapter1
	lpVtbl As IDXGIAdapter1Vtbl Ptr
End Type

Type DXGI_RECT
	left   As Long
	top    As Long
	right  As Long
	bottom As Long
End Type

Type DXGI_PRESENT_PARAMETERS
	DirtyRectsCount As UInteger
	pDirtyRects     As RECT Ptr          ' RECT is already defined in Windows headers
	pScrollRect     As DXGI_RECT Ptr
	pScrollOffset   As Point Ptr
End Type

Type IDXGISwapChain1Vtbl
	' IUnknown
	QueryInterface  As Function(This As Any Ptr, riid As REFIID, ppvObject As Any Ptr Ptr) As HRESULT
	AddRef          As Function(This As Any Ptr) As ULong
	Release         As Function(This As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData           As Function(This As Any Ptr, Name As REFGUID, DataSize As UINT, pData As Any Ptr) As HRESULT
	SetPrivateDataInterface  As Function(This As Any Ptr, Name As REFGUID, pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData           As Function(This As Any Ptr, Name As REFGUID, ByRef DataSize As UINT, pData As Any Ptr) As HRESULT
	GetParent                As Function(This As Any Ptr, riid As REFIID, ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIDeviceSubObject
	GetDevice                As Function(This As Any Ptr, riid As REFIID, ppDevice As Any Ptr Ptr) As HRESULT
	
	' IDXGISwapChain
	Present                  As Function(This As Any Ptr, SyncInterval As UINT, Flags As UINT) As HRESULT
	GetBuffer                As Function(This As Any Ptr, Buffer As UINT, riid As REFIID, ppSurface As Any Ptr Ptr) As HRESULT
	SetFullscreenState       As Function(This As Any Ptr, Fullscreen As BOOL, pTarget As IDXGIOutput Ptr) As HRESULT
	GetFullscreenState       As Function(This As Any Ptr, ByRef Fullscreen As BOOL, ppTarget As IDXGIOutput Ptr Ptr) As HRESULT
	GetDesc                  As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_DESC Ptr) As HRESULT
	ResizeBuffers            As Function(This As Any Ptr, BufferCount As UINT, Width As UINT, Height As UINT, NewFormat As DXGI_FORMAT, SwapChainFlags As UINT) As HRESULT
	ResizeTarget             As Function(This As Any Ptr, pNewTargetParameters As DXGI_MODE_DESC Ptr) As HRESULT
	GetContainingOutput      As Function(This As Any Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
	GetFrameStatistics       As Function(This As Any Ptr, pStats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
	GetLastPresentCount      As Function(This As Any Ptr, pLastPresentCount As UINT Ptr) As HRESULT
	
	' IDXGISwapChain1
	GetDesc1                 As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_DESC1 Ptr) As HRESULT
	GetFullscreenDesc        As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_FULLSCREEN_DESC Ptr) As HRESULT
	GetHwnd                  As Function(This As Any Ptr, phwnd As HWND Ptr) As HRESULT
	GetCoreWindow            As Function(This As Any Ptr, riid As REFIID, ppUnk As Any Ptr Ptr) As HRESULT
	Present1                 As Function(This As Any Ptr, SyncInterval As UINT, PresentFlags As UINT, pPresentParameters As DXGI_PRESENT_PARAMETERS Ptr) As HRESULT
	IsTemporaryMonoSupported As Function(This As Any Ptr) As BOOL
	GetRestrictToOutput      As Function(This As Any Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
	SetBackgroundColor       As Function(This As Any Ptr, pColor As D2D1_COLOR_F Ptr) As HRESULT
	GetBackgroundColor       As Function(This As Any Ptr, pColor As D2D1_COLOR_F Ptr) As HRESULT
	SetRotation              As Function(This As Any Ptr, Rotation As DXGI_MODE_ROTATION) As HRESULT
	GetRotation              As Function(This As Any Ptr, pRotation As DXGI_MODE_ROTATION Ptr) As HRESULT
End Type

Type IDXGISwapChain1
	lpVtbl As IDXGISwapChain1Vtbl Ptr
End Type

Type IDXGIFactory2 As IDXGIFactory2_

Type IDXGIFactory2Vtbl
	' IUnknown
	QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef         As Function(ByVal This As Any Ptr) As ULong
	Release        As Function(ByVal This As Any Ptr) As ULong
	
	' IDXGIObject
	SetPrivateData           As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface  As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData           As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
	GetParent                As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT
	
	' IDXGIFactory
	EnumAdapters             As Function(ByVal This As Any Ptr, ByVal Adapter As UINT, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT
	MakeWindowAssociation    As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal Flags As UINT) As HRESULT
	GetWindowAssociation     As Function(ByVal This As Any Ptr, ByRef pWindowHandle As HWND) As HRESULT
	CreateSwapChain          As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC, ByRef ppSwapChain As IDXGISwapChain Ptr) As HRESULT
	CreateSoftwareAdapter    As Function(ByVal This As Any Ptr, ByVal ModuleHandle As HMODULE, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT
	
	' IDXGIFactory1
	EnumAdapters1            As Function(ByVal This As Any Ptr, ByVal Adapter As UINT, ByVal ppAdapter As IDXGIAdapter1 Ptr Ptr) As HRESULT
	IsCurrent                As Function(ByVal This As Any Ptr) As BOOL
	
	' IDXGIFactory2
	IsWindowedStereoEnabled  As Function(ByVal This As Any Ptr) As BOOL
	CreateSwapChainForHwnd   As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByVal hWnd As HWND, pDesc As DXGI_SWAP_CHAIN_DESC1 Ptr, pFullscreenDesc As DXGI_SWAP_CHAIN_FULLSCREEN_DESC Ptr, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
	CreateSwapChainForCoreWindow As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByVal pWindow As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC1, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
	GetSharedResourceAdapterLuid As Function(ByVal This As Any Ptr, ByVal hResource As HANDLE, ByRef pLuid As LUID) As HRESULT
	RegisterStereoStatusWindow   As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal wMsg As UINT, ByRef pdwCookie As DWORD) As HRESULT
	RegisterStereoStatusEvent    As Function(ByVal This As Any Ptr, ByVal hEvent As HANDLE, ByRef pdwCookie As DWORD) As HRESULT
	UnregisterStereoStatus       As Sub(ByVal This As Any Ptr, ByVal dwCookie As DWORD)
	RegisterOcclusionStatusWindow As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal wMsg As UINT, ByRef pdwCookie As DWORD) As HRESULT
	RegisterOcclusionStatusEvent As Function(ByVal This As Any Ptr, ByVal hEvent As HANDLE, ByRef pdwCookie As DWORD) As HRESULT
	UnregisterOcclusionStatus    As Sub(ByVal This As Any Ptr, ByVal dwCookie As DWORD)
	CreateSwapChainForComposition As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC1, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
End Type

Type IDXGIFactory2_
	lpVtbl As IDXGIFactory2Vtbl Ptr
End Type

Dim Shared pD3D11DeviceContext As ID3D11DeviceContext Ptr

Const D3D10_SDK_VERSION = 29
Const D3D11_SDK_VERSION = 7

Type D3D11_CREATE_DEVICE_FLAG As Long
Enum
	D3D11_CREATE_DEVICE_SINGLETHREADED = &h1,
	D3D11_CREATE_DEVICE_DEBUG = &h2,
	D3D11_CREATE_DEVICE_SWITCH_TO_REF = &h4,
	D3D11_CREATE_DEVICE_PREVENT_INTERNAL_THREADING_OPTIMIZATIONS = &h8,
	D3D11_CREATE_DEVICE_BGRA_SUPPORT = &h20,
	D3D11_CREATE_DEVICE_DEBUGGABLE = &h40,
	D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY = &h80,
	D3D11_CREATE_DEVICE_DISABLE_GPU_TIMEOUT = &h100,
	D3D11_CREATE_DEVICE_VIDEO_SUPPORT = &h800
End Enum

Type D3D11CreateDeviceType As Function (ByVal pAdapter As IDXGIAdapter Ptr, ByVal DriverType As D3D_DRIVER_TYPE, ByVal Software As HMODULE, ByVal Flags As UINT, ByVal pFeatureLevels As Const D3D_FEATURE_LEVEL Ptr, ByVal FeatureLevels As UINT, ByVal SDKVersion As UINT, ByVal ppDevice As ID3D11Device Ptr Ptr, ByVal pFeatureLevelOut As D3D_FEATURE_LEVEL Ptr, ByVal ppImmediateContext As ID3D11DeviceContext Ptr Ptr) As HRESULT
Type DWriteCreateFactoryType As Function(ByVal factoryType As DWRITE_FACTORY_TYPE, ByVal IID As REFIID, ByVal factory As IDWriteFactory Ptr Ptr) As HRESULT
Type fnCreateTextFormat As Function(ByVal This As Any Ptr, ByVal fontName As Const WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As Long, ByVal FontStyle As Long, ByVal fontStretch As Long, ByVal fontSize As Single, ByVal localeName As Const WString Ptr, ByVal ppTextFormat As Any Ptr Ptr) As HRESULT
Dim Shared CreateTextFormat As fnCreateTextFormat
Type fnCreateHwndRenderTarget As Function(ByVal This As Any Ptr, ByVal renderTargetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal hwndRenderTargetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal outRenderTarget As Any Ptr Ptr) As Long
Dim Shared CreateHwndRenderTarget As fnCreateHwndRenderTarget
Const DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE = &h00000010

' Globals
Dim Shared As Any Ptr hD2D1 = 0
Dim Shared As Any Ptr hD3D11 = 0
Dim Shared As Any Ptr hDWrite = 0
Dim Shared As ID2D1Device Ptr pD2D1Device = 0
Dim Shared As ID3D11Device Ptr pD3D11Device = 0
Dim Shared As IDXGIFactory2 Ptr pDXGIFactory2 = 0
Dim Shared As ID2D1Factory Ptr pD2D1Factory = 0
Dim Shared As ID2D1Factory1 Ptr pD2D1Factory1 = 0
Dim Shared As IDWriteFactory Ptr pDWriteFactory = 0
Dim Shared As IDXGIAdapter Ptr pDXGIAdapter = 0
Dim Shared As IDXGIDevice Ptr pDXGIDevice = 0
Dim Shared As Boolean g_Direct2DEnabled

Type D3D11_DEBUG_FEATURE As Long
Enum
	D3D11_DEBUG_FEATURE_FLUSH_PER_RENDER_OP = &h1
	D3D11_DEBUG_FEATURE_FINISH_PER_RENDER_OP = &h2
	D3D11_DEBUG_FEATURE_PRESENT_PER_RENDER_OP = &h4
	D3D11_DEBUG_FEATURE_ALWAYS_DISCARD = &h8
	D3D11_DEBUG_FEATURE_NEVER_DISCARD = &h10
	D3D11_DEBUG_FEATURE_AVOID_BEHAVIOR_CHANGING_DEBUG_AIDS = &h20
End Enum

Type ID3D11DebugVtbl
	' IUnknown
	QueryInterface As Function(ByVal This As Any Ptr, ByRef riid As GUID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef As Function(ByVal This As Any Ptr) As ULong
	Release As Function(ByVal This As Any Ptr) As ULong
	
	' ID3D11Debug
	SetFeatureMask As Function(ByVal This As Any Ptr, ByVal Mask As D3D11_DEBUG_FEATURE) As HRESULT
	GetFeatureMask As Function(ByVal This As Any Ptr, ByVal pMask As ULong Ptr) As HRESULT
	SetPresentPerRenderOpDelay As Function(ByVal This As Any Ptr, ByVal Milliseconds As ULong) As HRESULT
	GetPresentPerRenderOpDelay As Function(ByVal This As Any Ptr, ByVal pMilliseconds As ULong Ptr) As HRESULT
	SetSwapChain As Function(ByVal This As Any Ptr, ByVal pSwapChain As Any Ptr) As HRESULT
	GetSwapChain As Function(ByVal This As Any Ptr, ByVal ppSwapChain As Any Ptr Ptr) As HRESULT
	ValidateContext As Function(ByVal This As Any Ptr, ByVal pContext As Any Ptr) As HRESULT
	ReportLiveDeviceObjects As Function(ByVal This As Any Ptr, ByVal Flags As ULong) As HRESULT
	ValidateContextForDispatch As Function(ByVal This As Any Ptr, ByVal pContext As Any Ptr) As HRESULT
End Type

Type ID3D11Debug
	lpVtbl As ID3D11DebugVtbl Ptr
End Type

Dim Shared IID_ID3D11Debug As GUID = (&h79CF2233, &h7536, &h4948, { &h9D, &h36, &h1E, &h46, &h92, &hDC, &h57, &h60 } )

Const D3D11_RLO_SUMMARY = 0
Const D3D11_RLO_DETAIL = 1

Dim Shared IID_ID2D1Debug1 As GUID = ( _
&H429A1A06, &H0DDB, &H4C9C, {&H9A, &H3E, &H0C, &H0A, &H6B, &H56, &hA3, &HE0} )

Type ID2D1Debug1Vtbl
	' IUnknown
	QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef As Function(ByVal This As Any Ptr) As ULong
	Release As Function(ByVal This As Any Ptr) As ULong
	
	' ID2D1Debug
	EnableDebugLayer As Sub(ByVal This As Any Ptr)
	
	' ID2D1Debug1
	ReportLiveObjects As Function(ByVal This As Any Ptr, ByVal level As D2D1_DEBUG_LEVEL) As HRESULT
End Type

Type ID2D1Debug1
	lpVtbl As ID2D1Debug1Vtbl Ptr
End Type

Function UnloadD2D1 As Long
	#ifdef __USE_WINAPI__
		Dim pDebug As ID3D11Debug Ptr
		Dim pDebugD2D1 As ID2D1Debug1 Ptr
		' Проверяем, что pD3D11Device существует
		If pDWriteFactory Then Cast(Sub(ByVal As Any Ptr), COM_METHOD(pDWriteFactory, 2))(pDWriteFactory): pDWriteFactory = 0
		If pDXGIAdapter <> 0 Then pDXGIAdapter->lpVtbl->Release(pDXGIAdapter): pDXGIAdapter = 0
		If pDXGIDevice <> 0 Then pDXGIDevice->lpVtbl->Release(pDXGIDevice): pDXGIDevice = 0
		If pD3D11DeviceContext Then
			pD3D11DeviceContext->lpVtbl->OMSetRenderTargets(pD3D11DeviceContext, 0, 0, 0)
			pD3D11DeviceContext->lpVtbl->ClearState(pD3D11DeviceContext)
			pD3D11DeviceContext->lpVtbl->Flush(pD3D11DeviceContext)
			pD3D11DeviceContext->lpVtbl->Release(pD3D11DeviceContext)
			pD3D11DeviceContext = 0
		End If
		If pD3D11Device Then
			If SUCCEEDED(pD3D11Device->lpVtbl->QueryInterface(pD3D11Device, @IID_ID3D11Debug, @pDebug)) Then
				
			End If
			pD3D11Device->lpVtbl->Release(pD3D11Device): pD3D11Device = 0
		End If
		If pD2D1Device Then pD2D1Device->lpVtbl->Release(pD2D1Device): pD2D1Device = 0
		If pD2D1Factory Then Cast(Sub(ByVal As Any Ptr), COM_METHOD(pD2D1Factory, 2))(pD2D1Factory): pD2D1Factory = 0
		If pD2D1Factory1 Then
			'Dim D2D1GetDebugInterface As D2D1GetDebugInterfaceType
			'D2D1GetDebugInterface = Cast(D2D1CreateFactoryType, DyLibSymbol(hD2D1, "D2D1GetDebugInterface"))
			'If D2D1GetDebugInterface <> 0 Then
			'	Var hr = D2D1GetDebugInterface(@IID_ID2D1Debug1, @pDebugD2D1)
			'	If hr = 0 Then
			'		pDebugD2D1->lpVtbl->ReportLiveObjects(pDebug, D2D1_DEBUG_LEVEL_INFORMATION)
			'		pDebugD2D1->lpVtbl->Release(pDebug)
			'	End If
			'End If
			pD2D1Factory1->lpVtbl->Release(pD2D1Factory1): pD2D1Factory1 = 0
		End If
		If pDXGIFactory2 Then pDXGIFactory2->lpVtbl->Release(pDXGIFactory2): pDXGIFactory2 = 0
		If hD2D1 Then DyLibFree(hD2D1): hD2D1 = 0
		If hD3D11 Then DyLibFree(hD3D11): hD3D11 = 0
		If hDWrite Then DyLibFree(hDWrite): hDWrite = 0
		If pDebug <> 0 Then
			' 0 = D3D11_RLO_SUMMARY (короткий отчёт)
			' 1 = D3D11_RLO_DETAIL  (подробный отчёт с именами)
			OutputDebugString("===== D3D11 ReportLiveObjects START =====" & Chr(13,10))
			pDebug->lpVtbl->ReportLiveDeviceObjects(pDebug, D3D11_RLO_DETAIL Or D3D11_RLO_SUMMARY)
			OutputDebugString("===== D3D11 ReportLiveObjects END =====" & Chr(13,10))
			pDebug->lpVtbl->Release(pDebug)
		End If
		'CoUninitialize()
	#endif
	Return 0
End Function

#ifdef __USE_WINAPI__
	Type fnCreateTextLayout As Function(ByVal This As IDWriteFactory Ptr, ByVal text As LPCWSTR, ByVal textLength As UINT32, ByVal fformat As IDWriteTextFormat Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As IDWriteTextLayout Ptr Ptr) As HRESULT
	Dim Shared CreateTextLayout As fnCreateTextLayout
	Type D2D1CreateFactoryType As Function(ByVal factoryType As Long, ByVal riid As Const GUID Ptr, ByVal pFactoryOptions As D2D1_FACTORY_OPTIONS Ptr, ByVal ppIFactory As Any Ptr Ptr) As Long
	Type D2D1GetDebugInterfaceType As Function(ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr) As HRESULT
	Function IsWindows7OrLower() As Boolean
		Dim ver As RTL_OSVERSIONINFOW
		ver.dwOSVersionInfoSize = Len(ver)
		
		Dim RtlGetVersion As Function(ByRef lpVersionInformation As RTL_OSVERSIONINFOW) As Long
		Var hntdll = DyLibLoad("ntdll.dll")
		If hntdll = 0 Then
			Return False
		End If
		
		RtlGetVersion = DyLibSymbol(hntdll, "RtlGetVersion")
		If RtlGetVersion = 0 Then
			Return False
		End If
		
		If RtlGetVersion(ver) <> 0 Then
			Return False
		End If
		
		If ver.dwMajorVersion < 6 Then
			Return True      ' Windows XP and lower
		ElseIf ver.dwMajorVersion = 6 And ver.dwMinorVersion <= 1 Then
			Return True      ' Windows Vista or Windows 7
		End If
		Return False         ' Windows 8 and upper
	End Function
#endif

Function LoadD2D1 As Long
	#ifdef __USE_WINAPI__
		'CoInitializeEx(0, 0)
		If IsWindows7OrLower Then Return 0
		
		hD2D1 = DyLibLoad("d2d1.dll")
		If hD2D1 = 0 Then Return UnloadD2D1
		
		Dim CreateD2D1Factory As D2D1CreateFactoryType
		CreateD2D1Factory = Cast(D2D1CreateFactoryType, DyLibSymbol(hD2D1, "D2D1CreateFactory"))
		If CreateD2D1Factory = 0 Then Return UnloadD2D1
		
		Dim opts As D2D1_FACTORY_OPTIONS
		opts.debugLevel = D2D1_DEBUG_LEVEL_INFORMATION
		Dim hr As Long
		hr = CreateD2D1Factory(D2D1_FACTORY_TYPE_SINGLE_THREADED, @IID_ID2D1Factory, @opts, @pD2D1Factory)
		If hr <> 0 Then
			Print __FUNCTION__ & " (Line " & __LINE__ & ") Create pD2D1Factory failure!"
			Return UnloadD2D1
		End If
		hr = CreateD2D1Factory(D2D1_FACTORY_TYPE_SINGLE_THREADED, @IID_ID2D1Factory1, 0, @pD2D1Factory1)
		If hr <> 0 Then Return UnloadD2D1
		hDWrite = DyLibLoad("dwrite.dll")
		If hDWrite = 0 Then Return UnloadD2D1
		
		Dim CreateFactory As DWriteCreateFactoryType
		CreateFactory = Cast(DWriteCreateFactoryType, DyLibSymbol(hDWrite, "DWriteCreateFactory"))
		If CreateFactory = 0 Then Return UnloadD2D1
		
		hr = CreateFactory(DWRITE_FACTORY_TYPE_SHARED, @IID_IDWriteFactory, @pDWriteFactory)
		If hr <> 0 Then Return UnloadD2D1
		
		hD3D11 = DyLibLoad("d3d11.dll")
		If hD3D11 = 0 Then Return UnloadD2D1
		
		Dim D3D11CreateDevice As D3D11CreateDeviceType
		D3D11CreateDevice = Cast(D3D11CreateDeviceType, DyLibSymbol(hD3D11, "D3D11CreateDevice"))
		If D3D11CreateDevice = 0 Then Return UnloadD2D1
		
		Dim pDXGI As Any Ptr = 0
		' Or D3D11_CREATE_DEVICE_DEBUG
		hr = D3D11CreateDevice(0, D3D_DRIVER_TYPE_HARDWARE, 0, D3D11_CREATE_DEVICE_BGRA_SUPPORT, 0, 0, D3D11_SDK_VERSION, @pD3D11Device, 0, @pD3D11DeviceContext)
		
		If hr <> 0 Then Return UnloadD2D1
		
		hr = pD3D11Device->lpVtbl->QueryInterface(pD3D11Device, @IID_IDXGIDevice, @pDXGIDevice)
		If hr <> 0 Then Return UnloadD2D1
		
		'pDXGIDevice->lpVtbl->SetMaximumFrameLatency
		
		hr = pD2D1Factory1->lpVtbl->CreateDevice(pD2D1Factory1, pDXGIDevice, @pD2D1Device)
		If hr <> 0 Then Return UnloadD2D1
		
		pDXGIDevice->lpVtbl->GetAdapter(pDXGIDevice, @pDXGIAdapter)
		
		'Dim As DXGI_ADAPTER_DESC adapterDesc
		'pAdapter->lpVtbl->GetDesc(pAdapter,  @adapterDesc)
		'Print "GPU: "; adapterDesc.Description
		'Print "VendorId: "; Hex(adapterDesc.VendorId)
		
		hr = pDXGIAdapter->lpVtbl->GetParent(pDXGIAdapter, @IID_IDXGIFactory2, Cast(Any Ptr Ptr, @pDXGIFactory2))
		If hr <> 0 Then Return UnloadD2D1
		CreateHwndRenderTarget = Cast(fnCreateHwndRenderTarget, COM_METHOD(pD2D1Factory1, 14))
		CreateTextFormat = Cast(fnCreateTextFormat, COM_METHOD(pDWriteFactory, 15))
		CreateTextLayout = Cast(fnCreateTextLayout, COM_METHOD(pDWriteFactory, 18))
		
		g_Direct2DEnabled = True
	#endif
	Return 0
End Function