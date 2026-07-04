'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
#define CODEC_FORCE_DWORD &h7FFFFFFF
' ============================================================
' Windows Imaging Component (WIC)
' ============================================================
' ------------------------------------------------------------
' Enums
' ------------------------------------------------------------
Type WICDecodeOptions As Long
Enum
    WICDecodeMetadataCacheOnDemand = &H00000000
    WICDecodeMetadataCacheOnLoad   = &H00000001
    WICMETADATACACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICBitmapCreateCacheOption As Long
Enum
    WICBitmapNoCache        = &H00000000
    WICBitmapCacheOnDemand  = &H00000001
    WICBitmapCacheOnLoad    = &H00000002
    WICBITMAPCREATECACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICBitmapAlphaChannelOption As Long
Enum
    WICBitmapUseAlpha               = &H00000000
    WICBitmapUsePremultipliedAlpha  = &H00000001
    WICBitmapIgnoreAlpha            = &H00000002
    WICBITMAPALPHACHANNELOPTIONS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICBitmapDecoderCapabilities As Long
Enum
    WICBitmapDecoderCapabilitySameEncoder        = &H00000001
    WICBitmapDecoderCapabilityCanDecodeAllImages = &H00000002
    WICBitmapDecoderCapabilityCanDecodeSomeImages= &H00000004
    WICBitmapDecoderCapabilityCanEnumerateMetadata = &H00000008
    WICBitmapDecoderCapabilityCanDecodeThumbnail = &H00000010
End Enum
Type WICBitmapDitherType As Long
Enum
    WICBitmapDitherTypeNone              = &H00000000
    WICBitmapDitherTypeSolid             = &H00000000
    WICBitmapDitherTypeOrdered4x4        = &H00000001
    WICBitmapDitherTypeOrdered8x8        = &H00000002
    WICBitmapDitherTypeOrdered16x16      = &H00000003
    WICBitmapDitherTypeSpiral4x4         = &H00000004
    WICBitmapDitherTypeSpiral8x8         = &H00000005
    WICBitmapDitherTypeDualSpiral4x4     = &H00000006
    WICBitmapDitherTypeDualSpiral8x8     = &H00000007
    WICBitmapDitherTypeErrorDiffusion    = &H00000008
    WICBITMAPDITHERTYPE_FORCE_DWORD      = CODEC_FORCE_DWORD
End Enum
Type WICBitmapEncoderCacheOption As Long
Enum
    WICBitmapEncoderCacheInMemory = &H00000000
    WICBitmapEncoderCacheTempFile = &H00000001
    WICBitmapEncoderNoCache       = &H00000002
    WICBITMAPENCODERCACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICBitmapInterpolationMode As Long
Enum
    WICBitmapInterpolationModeNearestNeighbor = &H00000000
    WICBitmapInterpolationModeLinear          = &H00000001
    WICBitmapInterpolationModeCubic           = &H00000002
    WICBitmapInterpolationModeFant            = &H00000003
    WICBITMAPINTERPOLATIONMODE_FORCE_DWORD    = CODEC_FORCE_DWORD
End Enum
Type WICBitmapLockFlags As Long
Enum
    WICBitmapLockRead  = &H00000001
    WICBitmapLockWrite = &H00000002
    WICBITMAPLOCKFLAGS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICBitmapPaletteType As Long
Enum
    WICBitmapPaletteTypeCustom            = &H00000000
    WICBitmapPaletteTypeMedianCut         = &H00000001
    WICBitmapPaletteTypeFixedBW           = &H00000002
    WICBitmapPaletteTypeFixedHalftone8    = &H00000003
    WICBitmapPaletteTypeFixedHalftone27   = &H00000004
    WICBitmapPaletteTypeFixedHalftone64   = &H00000005
    WICBitmapPaletteTypeFixedHalftone125  = &H00000006
    WICBitmapPaletteTypeFixedHalftone216  = &H00000007
    WICBitmapPaletteTypeFixedWebPalette   = WICBitmapPaletteTypeFixedHalftone216
    WICBitmapPaletteTypeFixedHalftone252  = &H00000008
    WICBitmapPaletteTypeFixedHalftone256  = &H00000009
    WICBitmapPaletteTypeFixedGray4        = &H0000000A
    WICBitmapPaletteTypeFixedGray16       = &H0000000B
    WICBitmapPaletteTypeFixedGray256      = &H0000000C
    WICBITMAPPALETTETYPE_FORCE_DWORD      = CODEC_FORCE_DWORD
End Enum
Type WICBitmapTransformOptions As Long
Enum
    WICBitmapTransformRotate0         = &H00000000
    WICBitmapTransformRotate90        = &H00000001
    WICBitmapTransformRotate180       = &H00000002
    WICBitmapTransformRotate270       = &H00000003
    WICBitmapTransformFlipHorizontal  = &H00000008
    WICBitmapTransformFlipVertical    = &H00000010
    WICBITMAPTRANSFORMOPTIONS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICColorContextType As Long
Enum
    WICColorContextUninitialized  = &H00000000
    WICColorContextProfile        = &H00000001
    WICColorContextExifColorSpace = &H00000002
End Enum
Type WICComponentType As Long
Enum
    WICDecoder               = &H00000001
    WICEncoder               = &H00000002
    WICPixelFormatConverter  = &H00000004
    WICMetadataReader        = &H00000008
    WICMetadataWriter        = &H00000010
    WICPixelFormat           = &H00000020
    WICCOMPONENTTYPE_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICComponentSigning As Long
Enum
    WICComponentSigned   = &H00000001
    WICComponentUnsigned = &H00000002
    WICComponentSafe     = &H00000004
    WICComponentDisabled = &H80000000
End Enum
Type WICComponentEnumerateOptions As Long
Enum
    WICComponentEnumerateDefault      = &H00000000
    WICComponentEnumerateRefresh      = &H00000001
    WICComponentEnumerateBuiltInOnly  = &H20000000
    WICComponentEnumerateUnsigned     = &H40000000
    WICComponentEnumerateDisabled     = &H80000000
End Enum
Type WICJpegYCrCbSubsamplingOption As Long
Enum
    WICJpegYCrCbSubsamplingDefault = &H00000000
    WICJpegYCrCbSubsampling420     = &H00000001
    WICJpegYCrCbSubsampling422     = &H00000002
    WICJpegYCrCbSubsampling444     = &H00000003
    WICJpegYCrCbSubsampling440     = &H00000004
End Enum
Type WICPixelFormatNumericRepresentation As Long
Enum
    WICPixelFormatNumericRepresentationUnspecified = &H00000000
    WICPixelFormatNumericRepresentationIndexed     = &H00000001
    WICPixelFormatNumericRepresentationUnsignedInteger = &H00000002
    WICPixelFormatNumericRepresentationSignedInteger   = &H00000003
    WICPixelFormatNumericRepresentationFixed        = &H00000004
    WICPixelFormatNumericRepresentationFloat        = &H00000005
    WICPIXELFORMATNUMERICREPRESENTATION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICTiffCompressionOption As Long
Enum
    WICTiffCompressionDontCare            = &H00000000
    WICTiffCompressionNone                = &H00000001
    WICTiffCompressionCCITT3              = &H00000002
    WICTiffCompressionCCITT4              = &H00000003
    WICTiffCompressionLZW                 = &H00000004
    WICTiffCompressionRLE                 = &H00000005
    WICTiffCompressionZIP                 = &H00000006
    WICTiffCompressionLZWHDifferencing    = &H00000007
    WICTIFFCOMPRESSIONOPTION_FORCE_DWORD  = CODEC_FORCE_DWORD
End Enum
Type WICPngFilterOption As Long
Enum
    WICPngFilterUnspecified = 0
    WICPngFilterNone        = 1
    WICPngFilterSub         = 2
    WICPngFilterUp          = 3
    WICPngFilterAverage     = 4
    WICPngFilterPaeth       = 5
    WICPngFilterAdaptive    = 6
    WICPNGFILTEROPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICSectionAccessLevel As Long
Enum
    WICSectionAccessLevelRead      = &H00000001
    WICSectionAccessLevelReadWrite = &H00000003
    WICSectionAccessLevel_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICDdsDimension As Long
Enum
    WICDdsTexture1D   = &H00000000
    WICDdsTexture2D   = &H00000001
    WICDdsTexture3D   = &H00000002
    WICDdsTextureCube = &H00000003
    WICDDSTEXTURE_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum
Type WICDdsAlphaMode As Long
Enum
    WICDdsAlphaModeUnknown        = &H00000000
    WICDdsAlphaModeStraight       = &H00000001
    WICDdsAlphaModePremultiplied  = &H00000002
    WICDdsAlphaModeOpaque         = &H00000003
    WICDdsAlphaModeCustom         = &H00000004
    WICDDSALPHAMODE_FORCE_DWORD   = CODEC_FORCE_DWORD
End Enum
' ------------------------------------------------------------
' GUID aliases
' ------------------------------------------------------------
Type As GUID WICPixelFormatGUID
Type As Const GUID Ptr REFWICPixelFormatGUID

' Interface Identifier (IIDs)
Dim Shared As GUID IID_IWICFormatConverter   = Type<GUID>(&h00000301, &hA8F2, &h4877, {&hBA, &h0A, &hFD, &h2B, &h66, &h45, &hFB, &h94})
Dim Shared As GUID IID_IWICImagingFactory    = Type<GUID>(&hEC5EC8A9, &hC395, &h4314, {&h9C, &h77, &h54, &hD7, &hA9, &h35, &hFF, &h70})
Dim Shared As GUID IID_IWICBitmap            = Type<GUID>(&h00000121, &hA8F2, &h4877, {&hBA, &h0A, &hFD, &h2B, &h66, &h45, &hFB, &h94})
Dim Shared As GUID IID_IWICBitmapLock        = Type<GUID>(&h00000123, &hA8F2, &h4877, {&hBA, &h0A, &hFD, &h2B, &h66, &h45, &hFB, &h94})
Dim Shared As GUID IID_IWICBitmapEncoder     = Type<GUID>(&h00000103, &ha8f2, &h4877, {&hba, &h0a, &hfd, &h2b, &h66, &h45, &hfb, &h94})
Dim Shared As GUID IID_IWICBitmapFrameEncode = Type<GUID>(&h00000105, &ha8f2, &h4877, {&hba, &h0a, &hfd, &h2b, &h66, &h45, &hfb, &h94})
Dim Shared As GUID IID_IWICStream            = Type<GUID>(&h135ff860, &h22b7, &h4ddf, {&hb0, &hf7, &h23, &h8f, &h4a, &h00, &hde, &h6d})
' Categories
Dim Shared As GUID CLSID_WICImagingCategories = Type<GUID>(&HFAE3D380, &HFEA4, &H4623, {&H8C, &H75, &HC6, &HB6, &H11, &H10, &HB6, &H81})
Dim Shared As GUID CATID_WICBitmapDecoders = Type<GUID>(&H7ED96837, &H96F0, &H4812, {&HB2, &H11, &HF1, &H3C, &H24, &H11, &H7E, &HD3})
Dim Shared As GUID CATID_WICBitmapEncoders = Type<GUID>(&HAC757296, &H3522, &H4E11, {&H98, &H62, &HC1, &H7B, &HE5, &HA1, &H76, &H7E})
Dim Shared As GUID CATID_WICFormatConverters = Type<GUID>(&H7835EAE8, &HBF14, &H49D1, {&H93, &HCE, &H53, &H3A, &H40, &H7B, &H22, &H48})
Dim Shared As GUID CATID_WICMetadataReader = Type<GUID>(&H05AF94D8, &H7174, &H4CD2, {&HBE, &H4A, &H41, &H24, &HB8, &H0E, &HE4, &HB8})
Dim Shared As GUID CATID_WICMetadataWriter = Type<GUID>(&HABE3B9A4, &H257D, &H4B97, {&HBD, &H1A, &H29, &H4A, &HF4, &H96, &H22, &H2E})
Dim Shared As GUID CATID_WICPixelFormats = Type<GUID>(&H2B46E70F, &HCDA7, &H473E, {&H89, &HF6, &HDC, &H96, &H30, &HA2, &H39, &H0B})
' Factory
Dim Shared As GUID CLSID_WICImagingFactory = Type<GUID>(&HCACAF262, &H9370, &H4615, {&HA1, &H3B, &H9F, &H55, &H39, &HDA, &H4C, &H0A})
Dim Shared As GUID CLSID_WICImagingFactory1 = Type<GUID>(&HCACAF262, &H9370, &H4615, {&HA1, &H3B, &H9F, &H55, &H39, &HDA, &H4C, &H0A})
Dim Shared As GUID CLSID_WICImagingFactory2 = Type<GUID>(&H317D06E8, &H5F24, &H433D, {&HBD, &HF7, &H79, &HCE, &H68, &HD8, &HAB, &HC2})
' Decoder CLSIDs
Dim Shared As GUID CLSID_WICBmpDecoder = Type<GUID>(&H6B462062, &H7CBF, &H400D, {&H9F, &HDB, &H81, &H3D, &HD1, &H0F, &H27, &H78})
Dim Shared As GUID CLSID_WICPngDecoder = Type<GUID>(&H389EA17B, &H5078, &H4CDE, {&HB6, &HEF, &H25, &HC1, &H51, &H75, &HC7, &H51})
Dim Shared As GUID CLSID_WICPngDecoder1 = Type<GUID>(&H389EA17B, &H5078, &H4CDE, {&HB6, &HEF, &H25, &HC1, &H51, &H75, &HC7, &H51})
Dim Shared As GUID CLSID_WICPngDecoder2 = Type<GUID>(&HE018945B, &HAA86, &H4008, {&H9B, &HD4, &H67, &H77, &HA1, &HE4, &H0C, &H11})
Dim Shared As GUID CLSID_WICIcoDecoder = Type<GUID>(&HC61BFCDF, &H2E0F, &H4AAD, {&HA8, &HD7, &HE0, &H6B, &HAF, &HEB, &HCD, &HFE})
Dim Shared As GUID CLSID_WICJpegDecoder = Type<GUID>(&H9456A480, &HE88B, &H43EA, {&H9E, &H73, &H0B, &H2D, &H9B, &H71, &HB1, &HCA})
Dim Shared As GUID CLSID_WICGifDecoder = Type<GUID>(&H381DDA3C, &H9CE9, &H4834, {&HA2, &H3E, &H1F, &H98, &HF8, &HFC, &H52, &HBE})
Dim Shared As GUID CLSID_WICTiffDecoder = Type<GUID>(&HB54E85D9, &HFE23, &H499F, {&H8B, &H88, &H6A, &HCE, &HA7, &H13, &H75, &H2B})
Dim Shared As GUID CLSID_WICWmpDecoder = Type<GUID>(&HA26CEC36, &H234C, &H4950, {&HAE, &H16, &HE3, &H4A, &HAC, &HE7, &H1D, &H0D})
Dim Shared As GUID CLSID_WICDdsDecoder = Type<GUID>(&H9053699F, &HA341, &H429D, {&H9E, &H90, &HEE, &H43, &H7C, &HF8, &H0C, &H73})
' Encoder CLSIDs
Dim Shared As GUID CLSID_WICBmpEncoder = Type<GUID>(&H69BE8BB4, &HD66D, &H47C8, {&H86, &H5A, &HED, &H15, &H89, &H43, &H37, &H82})
Dim Shared As GUID CLSID_WICPngEncoder = Type<GUID>(&H27949969, &H876A, &H41D7, {&H94, &H47, &H56, &H8F, &H6A, &H35, &HA4, &HDC})
Dim Shared As GUID CLSID_WICJpegEncoder = Type<GUID>(&H1A34F5C1, &H4A5A, &H46DC, {&HB6, &H44, &H1F, &H45, &H67, &HE7, &HA6, &H76})
Dim Shared As GUID CLSID_WICGifEncoder = Type<GUID>(&H114F5598, &H0B22, &H40A0, {&H86, &HA1, &HC8, &H3E, &HA4, &H95, &HAD, &HBD})
Dim Shared As GUID CLSID_WICTiffEncoder = Type<GUID>(&H0131BE10, &H2001, &H4C5F, {&HA9, &HB0, &HCC, &H88, &HFA, &HB6, &H4C, &HE8})
Dim Shared As GUID CLSID_WICWmpEncoder = Type<GUID>(&HAC4CE3CB, &HE1C1, &H44CD, {&H82, &H15, &H5A, &H16, &H65, &H50, &H9E, &HC2})
Dim Shared As GUID CLSID_WICDdsEncoder = Type<GUID>(&HA61DDE94, &H66CE, &H4AC1, {&H88, &H1B, &H71, &H68, &H05, &H88, &H89, &H5E})
Dim Shared As GUID CLSID_WICAdngDecoder = Type<GUID>(&H981D9411, &H909E, &H42A7, {&H8F, &H5D, &HA7, &H47, &HFF, &H05, &H2E, &HDB})
Dim Shared As GUID CLSID_WICHeifDecoder = Type<GUID>(&HE9A4A80A, &H44FE, &H4DE4, {&H89, &H71, &H71, &H50, &HB1, &H0A, &H51, &H99})
Dim Shared As GUID CLSID_WICHeifEncoder = Type<GUID>(&H0DBECEC1, &H9EB3, &H4860, {&H9C, &H6F, &HDD, &HBE, &H86, &H63, &H45, &H75})
Dim Shared As GUID CLSID_WICWebpDecoder = Type<GUID>(&H7693E886, &H51C9, &H4070, {&H84, &H19, &H9F, &H70, &H73, &H8E, &HC8, &HFA})
Dim Shared As GUID CLSID_WICRAWDecoder = Type<GUID>(&H41945702, &H8302, &H44A6, {&H94, &H45, &HAC, &H98, &HE8, &HAF, &HA0, &H86})
' Format Converter
Dim Shared As GUID CLSID_WICDefaultFormatConverter = Type<GUID>(&H1A3F11DC, &HB514, &H4B17, {&H8C, &H5F, &H21, &H54, &H51, &H38, &H52, &HF1})
Dim Shared As GUID CLSID_WICFormatConverterHighColor = Type<GUID>(&HAC75D454, &H9F37, &H48F8, {&HB9, &H72, &H4E, &H19, &HBC, &H85, &H60, &H11})
Dim Shared As GUID CLSID_WICFormatConverterNChannel = Type<GUID>(&HC17CABB2, &HD4A3, &H47D7, {&HA5, &H57, &H33, &H9B, &H2E, &HFB, &HD4, &HF1})
Dim Shared As GUID CLSID_WICFormatConverterWMPhoto = Type<GUID>(&H9CB5172B, &HD600, &H46BA, {&HAB, &H77, &H77, &HBB, &H7E, &H3A, &H00, &HD9})
Dim Shared As GUID CLSID_WICPlanarFormatConverter = Type<GUID>(&H184132B8, &H32F8, &H4784, {&H91, &H31, &HDD, &H72, &H24, &HB2, &H34, &H38})
' Pixel Format GUIDs (DEFINE_GUID)
Dim Shared As GUID GUID_WICPixelFormatDontCare = Type<GUID>(&h6FDDC324, &h4E03, &h4BFE, {&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h00})
Dim Shared As GUID GUID_WICPixelFormatUndefined = Type<GUID>(&h6FDDC324, &h4E03, &h4BFE, {&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h00})
Dim Shared As GUID GUID_WICPixelFormat1bppIndexed = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h01})
Dim Shared As GUID GUID_WICPixelFormat2bppIndexed = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h02})
Dim Shared As GUID GUID_WICPixelFormat4bppIndexed = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h03})
Dim Shared As GUID GUID_WICPixelFormat8bppIndexed = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h04})
Dim Shared As GUID GUID_WICPixelFormatBlackWhite = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h05})
Dim Shared As GUID GUID_WICPixelFormat2bppGray = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h06})
Dim Shared As GUID GUID_WICPixelFormat4bppGray = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h07})
Dim Shared As GUID GUID_WICPixelFormat8bppGray = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h08})
Dim Shared As GUID GUID_WICPixelFormat16bppGray = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h09})
Dim Shared As GUID GUID_WICPixelFormat32bppGrayFloat = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h0B})
Dim Shared As GUID GUID_WICPixelFormat24bppBGR = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h0C})
Dim Shared As GUID GUID_WICPixelFormat24bppRGB = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h0D})
Dim Shared As GUID GUID_WICPixelFormat32bppBGR = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h0E})
Dim Shared As GUID GUID_WICPixelFormat32bppBGRA = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h0F})
Dim Shared As GUID GUID_WICPixelFormat32bppPBGRA = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h10})
Dim Shared As GUID GUID_WICPixelFormat48bppRGB = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h15})
Dim Shared As GUID GUID_WICPixelFormat64bppRGBA = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h16})
Dim Shared As GUID GUID_WICPixelFormat64bppPRGBA = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h17})
Dim Shared As GUID GUID_WICPixelFormat96bppRGBFloat = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h18})
Dim Shared As GUID GUID_WICPixelFormat128bppRGBAFloat = Type<GUID>(&h6FDDC324,&h4E03,&h4BFE,{&hB1,&h85,&h3D,&h77,&h76,&h8D,&hC9,&h19})
' Container Formats
Dim Shared As GUID GUID_ContainerFormatBmp = Type<GUID>(&H0AF1D87E, &HFCFE, &H4188, {&HBD, &HEB, &HA7, &H90, &H64, &H71, &HCB, &HE3})
Dim Shared As GUID GUID_ContainerFormatPng = Type<GUID>(&H1B7CFAF4, &H713F, &H473C, {&HBB, &HCD, &H61, &H37, &H42, &H5F, &HAE, &HAF})
Dim Shared As GUID GUID_ContainerFormatIco = Type<GUID>(&HA3A860C4, &H338F, &H4C17, {&H91, &H9A, &HFB, &HA4, &HB5, &H62, &H8F, &H21})
Dim Shared As GUID GUID_ContainerFormatJpeg = Type<GUID>(&H19E4A5AA, &H5662, &H4FC5, {&HA0, &HC0, &H17, &H58, &H02, &H8E, &H10, &H57})
Dim Shared As GUID GUID_ContainerFormatTiff = Type<GUID>(&H163BCC30, &HE2E9, &H4F0B, {&H96, &H1D, &HA3, &HE9, &HFD, &HB7, &H88, &HA3})
Dim Shared As GUID GUID_ContainerFormatGif = Type<GUID>(&H1F8A5601, &H7D4D, &H4CBD, {&H9C, &H82, &H1B, &HC8, &HD4, &HEE, &HB9, &HA5})
Dim Shared As GUID GUID_ContainerFormatWmp = Type<GUID>(&H57A37CAA, &H367A, &H4540, {&H91, &H6B, &HF1, &H83, &HC5, &H09, &H3A, &H4B})
Dim Shared As GUID GUID_ContainerFormatDds = Type<GUID>(&H9967CB95, &H2E85, &H4AC8, {&H8C, &HA2, &H83, &HD7, &HCC, &HD4, &H25, &HC9})
Dim Shared As GUID GUID_ContainerFormatAdng = Type<GUID>(&HF3FF6D0D, &H38C0, &H41C4, {&HB1, &HFE, &H1F, &H38, &H24, &HF1, &H7B, &H84})
Dim Shared As GUID GUID_ContainerFormatHeif = Type<GUID>(&HE1E62521, &H6787, &H405B, {&HA3, &H39, &H50, &H07, &H15, &HB5, &H76, &H3F})
Dim Shared As GUID GUID_ContainerFormatWebp = Type<GUID>(&HE094B0E2, &H67F2, &H45B3, {&HB0, &HEA, &H11, &H53, &H37, &HCA, &H7c, &HF3})
Dim Shared As GUID GUID_ContainerFormatRaw = Type<GUID>(&HFE99CE60, &HF19C, &H433C, {&HA3, &HAE, &H00, &HAC, &HEF, &HA9, &HCA, &H21})
' Vendors
Dim Shared As GUID GUID_VendorMicrosoft = Type<GUID>(&HF0E749CA, &HEDEF, &H4589, {&HA7, &H3A, &HEE, &H0E, &H62, &H6A, &H2A, &H2B})
Dim Shared As GUID GUID_VendorMicrosoftBuiltIn = Type<GUID>(&H257A30FD, &H06B6, &H462B, {&HAE, &HA4, &H63, &HF7, &H0B, &H86, &HE5, &H33})

' ============================================================
' WIC Structs
' ============================================================
Type WICRect
    X      As Long        ' INT
    Y      As Long        ' INT
    Width  As Long        ' INT
    Height As Long        ' INT
End Type
Type WICBitmapPattern
    Position    As ULARGE_INTEGER
    Length      As ULong          ' ULONG
    Pattern     As UByte Ptr      ' BYTE*
    Mask        As UByte Ptr      ' BYTE*
    EndOfStream As Long           ' BOOL (INT)
End Type
Type WICImageParameters
    PixelFormat As D2D1_PIXEL_FORMAT
    DpiX        As Single         ' FLOAT
    DpiY        As Single         ' FLOAT
    Top         As Single         ' FLOAT
    Left        As Single         ' FLOAT
    PixelWidth  As ULong          ' UINT32
    PixelHeight As ULong          ' UINT32
End Type
Type WICDdsParameters
    Width       As ULong          ' UINT
    Height      As ULong          ' UINT
    Depth       As ULong          ' UINT
    MipLevels   As ULong          ' UINT
    ArraySize   As ULong          ' UINT
    DxgiFormat  As DXGI_FORMAT
    Dimension   As WICDdsDimension
    AlphaMode   As WICDdsAlphaMode
End Type
Type WICDdsFormatInfo
    DxgiFormat    As DXGI_FORMAT
    BytesPerBlock As ULong        ' UINT
    BlockWidth    As ULong        ' UINT
    BlockHeight   As ULong        ' UINT
End Type

' ============================================================================
' Windows Imaging Component (WIC) Interfaces - Korrigierte Version
' ============================================================================
' WIC Interfaces
Type IUnknownWICVtbl As IUnknownWICVtbl_
Type IUnknownWIC
    lpVtbl As IUnknownWICVtbl Ptr
End Type
Type IUnknownWICVtbl_     '' Extends ObjectVtbl_
    QueryInterface As Function(ByVal This As IUnknownWIC Ptr, ByVal riid As Any Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IUnknownWIC Ptr) As ULong
    Release As Function(ByVal This As IUnknownWIC Ptr) As ULong
End Type
#define IUnknownWIC_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IUnknownWIC_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IUnknownWIC_Release(p, a) (p)->lpVtbl->Release(p, a)

' 2. Sequentieller Zugriff (Slots 4-5)
Type ISequentialStreamWICVtbl As ISequentialStreamWICVtbl_
Type ISequentialStreamWIC
    lpVtbl As ISequentialStreamWICVtbl Ptr
End Type
Type ISequentialStreamWICVtbl_     '' Extends IUnknownWICVtbl_
    QueryInterface As Function(ByVal This As ISequentialStreamWIC Ptr, ByVal riid As Any Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ISequentialStreamWIC Ptr) As ULong
    Release As Function(ByVal This As ISequentialStreamWIC Ptr) As ULong

    Read As Function(ByVal This As ISequentialStreamWIC Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbRead As ULong Ptr) As HRESULT
    Write As Function(ByVal This As ISequentialStreamWIC Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbWritten As ULong Ptr) As HRESULT
End Type
#define ISequentialStreamWIC_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ISequentialStreamWIC_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ISequentialStreamWIC_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ISequentialStreamWIC_Read(p, a, b, c) (p)->lpVtbl->Read(p, a, b, c)
#define ISequentialStreamWIC_Write(p, a, b, c) (p)->lpVtbl->Write(p, a, b, c)

' 3. Voller Stream Zugriff (Slots 6-14)
Type IStreamWICVtbl As IStreamWICVtbl_
Type IStreamWIC
    lpVtbl As IStreamWICVtbl Ptr
End Type
Type IStreamWICVtbl_     '' Extends ISequentialStreamWICVtbl_
    QueryInterface As Function(ByVal This As IStreamWIC Ptr, ByVal riid As Any Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IStreamWIC Ptr) As ULong
    Release As Function(ByVal This As IStreamWIC Ptr) As ULong
    Read As Function(ByVal This As IStreamWIC Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbRead As ULong Ptr) As HRESULT
    Write As Function(ByVal This As IStreamWIC Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbWritten As ULong Ptr) As HRESULT

    Seek As Function(ByVal This As IStreamWIC Ptr, ByVal dlibMove As LongInt, ByVal dwOrigin As ULong, ByVal plibNewPosition As LongInt Ptr) As HRESULT
    SetSize As Function(ByVal This As IStreamWIC Ptr, ByVal libNewSize As LongInt) As HRESULT
    CopyTo As Function(ByVal This As IStreamWIC Ptr, ByVal pstm As IStreamWIC Ptr, ByVal cb As LongInt, ByVal pcbRead As LongInt Ptr, ByVal pcbWritten As LongInt Ptr) As HRESULT
    Commit As Function(ByVal This As IStreamWIC Ptr, ByVal grfCommitFlags As ULong) As HRESULT
    Revert As Function(ByVal This As IStreamWIC Ptr) As HRESULT
    LockRegion As Function(ByVal This As IStreamWIC Ptr, ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    UnlockRegion As Function(ByVal This As IStreamWIC Ptr, ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    Stat As Function(ByVal This As IStreamWIC Ptr, ByVal pstatstg As Any Ptr, ByVal grfStatFlag As ULong) As HRESULT
    Clone As Function(ByVal This As IStreamWIC Ptr, ByVal ppstm As IStreamWIC Ptr Ptr) As HRESULT
End Type
#define IStreamWIC_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IStreamWIC_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IStreamWIC_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IStreamWIC_Read(p, a, b, c) (p)->lpVtbl->Read(p, a, b, c)
#define IStreamWIC_Write(p, a, b, c) (p)->lpVtbl->Write(p, a, b, c)
#define IStreamWIC_Seek(p, a, b, c) (p)->lpVtbl->Seek(p, a, b, c)
#define IStreamWIC_SetSize(p, a) (p)->lpVtbl->SetSize(p, a)
#define IStreamWIC_CopyTo(p, a, b, c, d) (p)->lpVtbl->CopyTo(p, a, b, c, d)
#define IStreamWIC_Commit(p, a) (p)->lpVtbl->Commit(p, a)
#define IStreamWIC_Revert(p, a) (p)->lpVtbl->Revert(p, a)
#define IStreamWIC_LockRegion(p, a, b, c) (p)->lpVtbl->LockRegion(p, a, b, c)
#define IStreamWIC_UnlockRegion(p, a, b, c) (p)->lpVtbl->UnlockRegion(p, a, b, c)
#define IStreamWIC_Stat(p, a, b) (p)->lpVtbl->Stat(p, a, b)
#define IStreamWIC_Clone(p, a) (p)->lpVtbl->Clone(p, a)


' ==============================
' IWICColorContext
' ==============================
Type IWICColorContextVtbl As IWICColorContextVtbl_
Type IWICColorContext
    lpVtbl As IWICColorContextVtbl Ptr
End Type
Type IWICColorContextVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICColorContext Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICColorContext Ptr) As ULong
    Release As Function(ByVal This As IWICColorContext Ptr) As ULong

    
    InitializeFromFilename As Function(ByVal This As IWICColorContext Ptr, ByVal wzFilename As WString Ptr) As HRESULT
        ' 5. InitializeFromMemory
    InitializeFromMemory As Function(ByVal This As IWICColorContext Ptr, ByVal pbBuffer As UByte Ptr, ByVal cbBufferSize As ULong) As HRESULT
        ' 6. InitializeFromExifColorSpace
    InitializeFromExifColorSpace As Function(ByVal This As IWICColorContext Ptr, ByVal value As ULong) As HRESULT
        ' 7. GetType
    GetType As Function(ByVal This As IWICColorContext Ptr, ByVal pType As ULong Ptr) As HRESULT
        ' 8. GetProfileBytes
    GetProfileBytes As Function(ByVal This As IWICColorContext Ptr, ByVal cbBuffer As ULong, ByVal pbBuffer As UByte Ptr, ByVal pcbActual As ULong Ptr) As HRESULT
        ' 9. GetExifColorSpace
    GetExifColorSpace As Function(ByVal This As IWICColorContext Ptr, ByVal pValue As ULong Ptr) As HRESULT
End Type
#define IWICColorContext_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICColorContext_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICColorContext_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICColorContext_InitializeFromFilename(p, a) (p)->lpVtbl->InitializeFromFilename(p, a)
#define IWICColorContext_InitializeFromMemory(p, a, b) (p)->lpVtbl->InitializeFromMemory(p, a, b)
#define IWICColorContext_InitializeFromExifColorSpace(p, a) (p)->lpVtbl->InitializeFromExifColorSpace(p, a)
#define IWICColorContext_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IWICColorContext_GetProfileBytes(p, a, b, c) (p)->lpVtbl->GetProfileBytes(p, a, b, c)
#define IWICColorContext_GetExifColorSpace(p, a) (p)->lpVtbl->GetExifColorSpace(p, a)


' ==============================
' IWICBitmapSource
' ==============================
Type IWICBitmapSourceVtbl As IWICBitmapSourceVtbl_
Type IWICBitmapSource
    lpVtbl As IWICBitmapSourceVtbl Ptr
End Type
Type IWICBitmapSourceVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapSource Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapSource Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapSource Ptr) As ULong

    GetSize As Function(ByVal This As IWICBitmapSource Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmapSource Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmapSource Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapSource Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmapSource Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT
End Type
#define IWICBitmapSource_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapSource_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapSource_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapSource_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapSource_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmapSource_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmapSource_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapSource_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)

' ==============================
' IWICBitmapLock
' ==============================
Type IWICBitmapLockVtbl As IWICBitmapLockVtbl_
Type IWICBitmapLock
    lpVtbl As IWICBitmapLockVtbl Ptr
End Type
Type IWICBitmapLockVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapLock Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapLock Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapLock Ptr) As ULong

    GetSize As Function(ByVal This As IWICBitmapLock Ptr, ByVal pWidth As ULong Ptr, ByVal pHeight As ULong Ptr) As HRESULT
        ' 5. GetStride
    GetStride As Function(ByVal This As IWICBitmapLock Ptr, ByVal pcbStride As ULong Ptr) As HRESULT
        ' 6. GetDataPointer
    GetDataPointer As Function(ByVal This As IWICBitmapLock Ptr, ByVal pcbBufferSize As ULong Ptr, ByVal ppbData As UByte Ptr Ptr) As HRESULT
        ' 7. GetPixelFormat
    GetPixelFormat As Function(ByVal This As IWICBitmapLock Ptr, ByVal pPixelFormat As GUID Ptr) As HRESULT
End Type
#define IWICBitmapLock_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapLock_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapLock_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapLock_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapLock_GetStride(p, a) (p)->lpVtbl->GetStride(p, a)
#define IWICBitmapLock_GetDataPointer(p, a, b) (p)->lpVtbl->GetDataPointer(p, a, b)
#define IWICBitmapLock_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)

' ==============================
' IWICBitmapFlipRotator
' ==============================
Type IWICBitmapFlipRotatorVtbl As IWICBitmapFlipRotatorVtbl_
Type IWICBitmapFlipRotator
    lpVtbl As IWICBitmapFlipRotatorVtbl Ptr
End Type
Type IWICBitmapFlipRotatorVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapFlipRotator Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapFlipRotator Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapFlipRotator Ptr) As ULong
    GetSize As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource
        ' 9. Initialize
    Initialize As Function(ByVal This As IWICBitmapFlipRotator Ptr,  ByVal pISource As IWICBitmapSource Ptr, ByVal options As WICBitmapTransformOptions ) As HRESULT
End Type
#define IWICBitmapFlipRotator_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapFlipRotator_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapFlipRotator_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapFlipRotator_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapFlipRotator_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmapFlipRotator_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmapFlipRotator_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapFlipRotator_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICBitmapFlipRotator_Initialize(p, a, b) (p)->lpVtbl->Initialize(p, a, b)

' ============================================================================
' IWICBitmap
' ============================================================================
Type IWICBitmapVtbl As IWICBitmapVtbl_
Type IWICBitmap
    lpVtbl As IWICBitmapVtbl Ptr
End Type
Type IWICBitmapVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICBitmap Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmap Ptr) As ULong
    Release As Function(ByVal This As IWICBitmap Ptr) As ULong
    GetSize As Function(ByVal This As IWICBitmap Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmap Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmap Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmap Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmap Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource (GetSize, GetPixelFormat, GetResolution, etc.)
        ' 9. Lock
    Lock As Function(ByVal This As IWICBitmap Ptr,  ByVal prcLock As Any Ptr, ByVal flags As ULong, ByVal ppILock As Any Ptr Ptr ) As HRESULT
        ' 10. SetPalette
    SetPalette As Function(ByVal This As IWICBitmap Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 11. SetResolution
    SetResolution As Function(ByVal This As IWICBitmap Ptr,  ByVal dpiX As Double, ByVal dpiY As Double ) As HRESULT
End Type
#define IWICBitmap_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmap_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmap_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmap_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmap_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmap_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmap_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmap_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICBitmap_Lock(p, a, b, c) (p)->lpVtbl->Lock(p, a, b, c)
#define IWICBitmap_SetPalette(p, a) (p)->lpVtbl->SetPalette(p, a)
#define IWICBitmap_SetResolution(p, a, b) (p)->lpVtbl->SetResolution(p, a, b)

' ============================================================================
' IWICPalette
' ============================================================================
Type IWICPaletteVtbl As IWICPaletteVtbl_
Type IWICPalette
    lpVtbl As IWICPaletteVtbl Ptr
End Type
Type IWICPaletteVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICPalette Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICPalette Ptr) As ULong
    Release As Function(ByVal This As IWICPalette Ptr) As ULong

    
    InitializePredefined As Function(ByVal This As IWICPalette Ptr,  ByVal ePaletteType As ULong, ByVal fAddTransparentColor As Long ) As HRESULT
        ' 5. InitializeCustom
    InitializeCustom As Function(ByVal This As IWICPalette Ptr,  ByVal pColors As ULong Ptr, ByVal cCount As ULong ) As HRESULT
        ' 6. InitializeFromBitmap
    InitializeFromBitmap As Function(ByVal This As IWICPalette Ptr,  ByVal pISurface As IWICBitmapSource Ptr, ByVal cCount As ULong, ByVal fAddTransparentColor As Long ) As HRESULT
        ' 7. InitializeFromPalette
    InitializeFromPalette As Function(ByVal This As IWICPalette Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. GetType
    GetType As Function(ByVal This As IWICPalette Ptr,  ByVal pePaletteType As ULong Ptr ) As HRESULT
        ' 9. GetColorCount
    GetColorCount As Function(ByVal This As IWICPalette Ptr,  ByVal pcCount As ULong Ptr ) As HRESULT
        ' 10. GetColors
    GetColors As Function(ByVal This As IWICPalette Ptr,  ByVal cCount As ULong, ByVal pColors As ULong Ptr, ByVal pcActualCount As ULong Ptr ) As HRESULT
        ' 11. IsBlackWhite
    IsBlackWhite As Function(ByVal This As IWICPalette Ptr,  ByVal pfIsBlackWhite As Long Ptr ) As HRESULT
        ' 12. IsGrayscale
    IsGrayscale As Function(ByVal This As IWICPalette Ptr,  ByVal pfIsGrayscale As Long Ptr ) As HRESULT
        ' 13. HasAlpha
    HasAlpha As Function(ByVal This As IWICPalette Ptr,  ByVal pfHasAlpha As Long Ptr ) As HRESULT
End Type
#define IWICPalette_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICPalette_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICPalette_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICPalette_InitializePredefined(p, a, b) (p)->lpVtbl->InitializePredefined(p, a, b)
#define IWICPalette_InitializeCustom(p, a, b) (p)->lpVtbl->InitializeCustom(p, a, b)
#define IWICPalette_InitializeFromBitmap(p, a, b, c) (p)->lpVtbl->InitializeFromBitmap(p, a, b, c)
#define IWICPalette_InitializeFromPalette(p, a) (p)->lpVtbl->InitializeFromPalette(p, a)
#define IWICPalette_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IWICPalette_GetColorCount(p, a) (p)->lpVtbl->GetColorCount(p, a)
#define IWICPalette_GetColors(p, a, b, c) (p)->lpVtbl->GetColors(p, a, b, c)
#define IWICPalette_IsBlackWhite(p, a) (p)->lpVtbl->IsBlackWhite(p, a)
#define IWICPalette_IsGrayscale(p, a) (p)->lpVtbl->IsGrayscale(p, a)
#define IWICPalette_HasAlpha(p, a) (p)->lpVtbl->HasAlpha(p, a)

' ============================================================================
' IWICComponentInfo
' ============================================================================
Type IWICComponentInfoVtbl As IWICComponentInfoVtbl_
Type IWICComponentInfo
    lpVtbl As IWICComponentInfoVtbl Ptr
End Type
Type IWICComponentInfoVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICComponentInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICComponentInfo Ptr) As ULong
    Release As Function(ByVal This As IWICComponentInfo Ptr) As ULong

        
    GetComponentType As Function(ByVal This As IWICComponentInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICComponentInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICComponentInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICComponentInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICComponentInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICComponentInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICComponentInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICComponentInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
End Type
#define IWICComponentInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICComponentInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICComponentInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICComponentInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICComponentInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICComponentInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICComponentInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICComponentInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICComponentInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICComponentInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICComponentInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)

' ============================================================================
' IWICMetadataQueryReader
' ============================================================================
Type IWICMetadataQueryReaderVtbl As IWICMetadataQueryReaderVtbl_
Type IWICMetadataQueryReader
    lpVtbl As IWICMetadataQueryReaderVtbl Ptr
End Type
Type IWICMetadataQueryReaderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICMetadataQueryReader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICMetadataQueryReader Ptr) As ULong
    Release As Function(ByVal This As IWICMetadataQueryReader Ptr) As ULong

        
    GetContainerFormat As Function(ByVal This As IWICMetadataQueryReader Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 5. GetLocation
    GetLocation As Function(ByVal This As IWICMetadataQueryReader Ptr,  ByVal cchMaxLength As ULong, ByVal wzNamespace As WString Ptr, ByVal pcchActualLength As ULong Ptr ) As HRESULT
        ' 6. GetMetadataByName
    GetMetadataByName As Function(ByVal This As IWICMetadataQueryReader Ptr,  ByVal wzName As WString Ptr, ByVal pvarValue As Any Ptr ) As HRESULT
        ' 7. GetEnumerator
    GetEnumerator As Function(ByVal This As IWICMetadataQueryReader Ptr,  ByVal ppIEnumString As Any Ptr Ptr ) As HRESULT
End Type
#define IWICMetadataQueryReader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICMetadataQueryReader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICMetadataQueryReader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICMetadataQueryReader_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICMetadataQueryReader_GetLocation(p, a, b, c) (p)->lpVtbl->GetLocation(p, a, b, c)
#define IWICMetadataQueryReader_GetMetadataByName(p, a, b) (p)->lpVtbl->GetMetadataByName(p, a, b)
#define IWICMetadataQueryReader_GetEnumerator(p, a) (p)->lpVtbl->GetEnumerator(p, a)

' ============================================================================
' IWICMetadataQueryWriter
' ============================================================================
Type IWICMetadataQueryWriterVtbl As IWICMetadataQueryWriterVtbl_
Type IWICMetadataQueryWriter
    lpVtbl As IWICMetadataQueryWriterVtbl Ptr
End Type
Type IWICMetadataQueryWriterVtbl_     '' Extends IWICMetadataQueryReaderVtbl_
    QueryInterface As Function(ByVal This As IWICMetadataQueryWriter Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICMetadataQueryWriter Ptr) As ULong
    Release As Function(ByVal This As IWICMetadataQueryWriter Ptr) As ULong
        
    GetContainerFormat As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 5. GetLocation
    GetLocation As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal cchMaxLength As ULong, ByVal wzNamespace As WString Ptr, ByVal pcchActualLength As ULong Ptr ) As HRESULT
        ' 6. GetMetadataByName
    GetMetadataByName As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal wzName As WString Ptr, ByVal pvarValue As Any Ptr ) As HRESULT
        ' 7. GetEnumerator
    GetEnumerator As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal ppIEnumString As Any Ptr Ptr ) As HRESULT

        ' 4-7. IWICMetadataQueryReader
        ' 8. SetMetadataByName
    SetMetadataByName As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal wzName As WString Ptr, ByVal pvarValue As Any Ptr ) As HRESULT
        ' 9. RemoveMetadataByName
    RemoveMetadataByName As Function(ByVal This As IWICMetadataQueryWriter Ptr,  ByVal wzName As WString Ptr ) As HRESULT
End Type
#define IWICMetadataQueryWriter_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICMetadataQueryWriter_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICMetadataQueryWriter_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICMetadataQueryWriter_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICMetadataQueryWriter_GetLocation(p, a, b, c) (p)->lpVtbl->GetLocation(p, a, b, c)
#define IWICMetadataQueryWriter_GetMetadataByName(p, a, b) (p)->lpVtbl->GetMetadataByName(p, a, b)
#define IWICMetadataQueryWriter_GetEnumerator(p, a) (p)->lpVtbl->GetEnumerator(p, a)
#define IWICMetadataQueryWriter_SetMetadataByName(p, a, b) (p)->lpVtbl->SetMetadataByName(p, a, b)
#define IWICMetadataQueryWriter_RemoveMetadataByName(p, a) (p)->lpVtbl->RemoveMetadataByName(p, a)

' ============================================================================
' IWICBitmapFrameDecode
' ============================================================================
Type IWICBitmapFrameDecodeVtbl As IWICBitmapFrameDecodeVtbl_
Type IWICBitmapFrameDecode
    lpVtbl As IWICBitmapFrameDecodeVtbl Ptr
End Type
Type IWICBitmapFrameDecodeVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapFrameDecode Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapFrameDecode Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapFrameDecode Ptr) As ULong
    GetSize As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource
        ' 9. GetMetadataQueryReader
    GetMetadataQueryReader As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal ppIMetadataQueryReader As Any Ptr Ptr ) As HRESULT
        ' 10. GetColorContexts
    GetColorContexts As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal cCount As ULong, ByVal ppIColorContexts As Any Ptr Ptr, ByVal pcActualCount As ULong Ptr ) As HRESULT
        ' 11. GetThumbnail
    GetThumbnail As Function(ByVal This As IWICBitmapFrameDecode Ptr,  ByVal ppIThumbnail As Any Ptr Ptr ) As HRESULT
End Type
#define IWICBitmapFrameDecode_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapFrameDecode_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapFrameDecode_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapFrameDecode_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapFrameDecode_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmapFrameDecode_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmapFrameDecode_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapFrameDecode_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICBitmapFrameDecode_GetMetadataQueryReader(p, a) (p)->lpVtbl->GetMetadataQueryReader(p, a)
#define IWICBitmapFrameDecode_GetColorContexts(p, a, b, c) (p)->lpVtbl->GetColorContexts(p, a, b, c)
#define IWICBitmapFrameDecode_GetThumbnail(p, a) (p)->lpVtbl->GetThumbnail(p, a)

' ============================================================================
' IWICPixelFormatInfo
' ============================================================================
Type IWICPixelFormatInfoVtbl As IWICPixelFormatInfoVtbl_
Type IWICPixelFormatInfo
    lpVtbl As IWICPixelFormatInfoVtbl Ptr
End Type
Type IWICPixelFormatInfoVtbl_     '' Extends IWICComponentInfoVtbl_
    QueryInterface As Function(ByVal This As IWICPixelFormatInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICPixelFormatInfo Ptr) As ULong
    Release As Function(ByVal This As IWICPixelFormatInfo Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
        ' 12. GetFormatGUID
    GetFormatGUID As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal pFormat As GUID Ptr ) As HRESULT
        ' 13. GetColorContext
    GetColorContext As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal ppIColorContext As Any Ptr Ptr ) As HRESULT
        ' 14. GetBitsPerPixel
    GetBitsPerPixel As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal puiBitsPerPixel As ULong Ptr ) As HRESULT
        ' 15. GetChannelCount
    GetChannelCount As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal puiChannelCount As ULong Ptr ) As HRESULT
        ' 16. GetChannelMask
    GetChannelMask As Function(ByVal This As IWICPixelFormatInfo Ptr,  ByVal uiChannelIndex As ULong, ByVal cbMaskBuffer As ULong, ByVal pbMaskBuffer As UByte Ptr, ByVal pcbActual As ULong Ptr ) As HRESULT
End Type
#define IWICPixelFormatInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICPixelFormatInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICPixelFormatInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICPixelFormatInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICPixelFormatInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICPixelFormatInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICPixelFormatInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICPixelFormatInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICPixelFormatInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICPixelFormatInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICPixelFormatInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICPixelFormatInfo_GetFormatGUID(p, a) (p)->lpVtbl->GetFormatGUID(p, a)
#define IWICPixelFormatInfo_GetColorContext(p, a) (p)->lpVtbl->GetColorContext(p, a)
#define IWICPixelFormatInfo_GetBitsPerPixel(p, a) (p)->lpVtbl->GetBitsPerPixel(p, a)
#define IWICPixelFormatInfo_GetChannelCount(p, a) (p)->lpVtbl->GetChannelCount(p, a)
#define IWICPixelFormatInfo_GetChannelMask(p, a, b, c, d) (p)->lpVtbl->GetChannelMask(p, a, b, c, d)

' ============================================================================
' IWICPixelFormatInfo2
' ============================================================================
Type IWICPixelFormatInfo2Vtbl As IWICPixelFormatInfo2Vtbl_
Type IWICPixelFormatInfo2
    lpVtbl As IWICPixelFormatInfo2Vtbl Ptr
End Type
Type IWICPixelFormatInfo2Vtbl_     '' Extends IWICPixelFormatInfoVtbl_
    QueryInterface As Function(ByVal This As IWICPixelFormatInfo2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICPixelFormatInfo2 Ptr) As ULong
    Release As Function(ByVal This As IWICPixelFormatInfo2 Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 4-11.  IWICComponentInfo
        ' 12. GetFormatGUID
    GetFormatGUID As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pFormat As GUID Ptr ) As HRESULT
        ' 13. GetColorContext
    GetColorContext As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal ppIColorContext As Any Ptr Ptr ) As HRESULT
        ' 14. GetBitsPerPixel
    GetBitsPerPixel As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal puiBitsPerPixel As ULong Ptr ) As HRESULT
        ' 15. GetChannelCount
    GetChannelCount As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal puiChannelCount As ULong Ptr ) As HRESULT
        ' 16. GetChannelMask
    GetChannelMask As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal uiChannelIndex As ULong, ByVal cbMaskBuffer As ULong, ByVal pbMaskBuffer As UByte Ptr, ByVal pcbActual As ULong Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
    
    SupportsTransparency As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pfSupportsTransparency As Long Ptr ) As HRESULT
        ' 18. GetNumericRepresentation
    GetNumericRepresentation As Function(ByVal This As IWICPixelFormatInfo2 Ptr,  ByVal pNumericRepresentation As ULong Ptr ) As HRESULT
End Type
#define IWICPixelFormatInfo2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICPixelFormatInfo2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICPixelFormatInfo2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICPixelFormatInfo2_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICPixelFormatInfo2_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICPixelFormatInfo2_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICPixelFormatInfo2_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICPixelFormatInfo2_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICPixelFormatInfo2_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICPixelFormatInfo2_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICPixelFormatInfo2_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICPixelFormatInfo2_GetFormatGUID(p, a) (p)->lpVtbl->GetFormatGUID(p, a)
#define IWICPixelFormatInfo2_GetColorContext(p, a) (p)->lpVtbl->GetColorContext(p, a)
#define IWICPixelFormatInfo2_GetBitsPerPixel(p, a) (p)->lpVtbl->GetBitsPerPixel(p, a)
#define IWICPixelFormatInfo2_GetChannelCount(p, a) (p)->lpVtbl->GetChannelCount(p, a)
#define IWICPixelFormatInfo2_GetChannelMask(p, a, b, c, d) (p)->lpVtbl->GetChannelMask(p, a, b, c, d)
#define IWICPixelFormatInfo2_SupportsTransparency(p, a) (p)->lpVtbl->SupportsTransparency(p, a)
#define IWICPixelFormatInfo2_GetNumericRepresentation(p, a) (p)->lpVtbl->GetNumericRepresentation(p, a)

' ============================================================================
' IWICBitmapCodecInfo
' ============================================================================
Type IWICBitmapCodecInfoVtbl As IWICBitmapCodecInfoVtbl_
Type IWICBitmapCodecInfo
    lpVtbl As IWICBitmapCodecInfoVtbl Ptr
End Type
Type IWICBitmapCodecInfoVtbl_     '' Extends IWICComponentInfoVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapCodecInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapCodecInfo Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapCodecInfo Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
        ' 12. GetContainerFormat
    GetContainerFormat As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 13. GetPixelFormats
    GetPixelFormats As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cFormats As ULong, ByVal pguidPixelFormats As GUID Ptr, ByVal pcActual As ULong Ptr ) As HRESULT
        ' 14. GetColorManagementVersion
    GetColorManagementVersion As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchColorManagementVersion As ULong, ByVal wzColorManagementVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 15. GetDeviceManufacturer
    GetDeviceManufacturer As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchDeviceManufacturer As ULong, ByVal wzDeviceManufacturer As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 16. GetDeviceModels
    GetDeviceModels As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchDeviceModels As ULong, ByVal wzDeviceModels As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 17. GetMimeTypes
    GetMimeTypes As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchMimeTypes As ULong, ByVal wzMimeTypes As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 18. GetFileExtensions
    GetFileExtensions As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal cchFileExtensions As ULong, ByVal wzFileExtensions As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 19. DoesSupportAnimation
    DoesSupportAnimation As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pfSupportAnimation As Long Ptr ) As HRESULT
        ' 20. DoesSupportChromakey
    DoesSupportChromakey As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pfSupportChromakey As Long Ptr ) As HRESULT
        ' 21. DoesSupportLossless
    DoesSupportLossless As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pfSupportLossless As Long Ptr ) As HRESULT
        ' 22. DoesSupportMultiframe
    DoesSupportMultiframe As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal pfSupportMultiframe As Long Ptr ) As HRESULT
        ' 23. MatchesMimeType
    MatchesMimeType As Function(ByVal This As IWICBitmapCodecInfo Ptr,  ByVal wzMimeType As WString Ptr, ByVal pfMatches As Long Ptr ) As HRESULT
End Type
#define IWICBitmapCodecInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapCodecInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapCodecInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapCodecInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICBitmapCodecInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICBitmapCodecInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICBitmapCodecInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICBitmapCodecInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICBitmapCodecInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICBitmapCodecInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICBitmapCodecInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICBitmapCodecInfo_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICBitmapCodecInfo_GetPixelFormats(p, a, b, c) (p)->lpVtbl->GetPixelFormats(p, a, b, c)
#define IWICBitmapCodecInfo_GetColorManagementVersion(p, a, b, c) (p)->lpVtbl->GetColorManagementVersion(p, a, b, c)
#define IWICBitmapCodecInfo_GetDeviceManufacturer(p, a, b, c) (p)->lpVtbl->GetDeviceManufacturer(p, a, b, c)
#define IWICBitmapCodecInfo_GetDeviceModels(p, a, b, c) (p)->lpVtbl->GetDeviceModels(p, a, b, c)
#define IWICBitmapCodecInfo_GetMimeTypes(p, a, b, c) (p)->lpVtbl->GetMimeTypes(p, a, b, c)
#define IWICBitmapCodecInfo_GetFileExtensions(p, a, b, c) (p)->lpVtbl->GetFileExtensions(p, a, b, c)
#define IWICBitmapCodecInfo_DoesSupportAnimation(p, a) (p)->lpVtbl->DoesSupportAnimation(p, a)
#define IWICBitmapCodecInfo_DoesSupportChromakey(p, a) (p)->lpVtbl->DoesSupportChromakey(p, a)
#define IWICBitmapCodecInfo_DoesSupportLossless(p, a) (p)->lpVtbl->DoesSupportLossless(p, a)
#define IWICBitmapCodecInfo_DoesSupportMultiframe(p, a) (p)->lpVtbl->DoesSupportMultiframe(p, a)
#define IWICBitmapCodecInfo_MatchesMimeType(p, a, b) (p)->lpVtbl->MatchesMimeType(p, a, b)

' ============================================================================
' IWICBitmapDecoderInfo
' ============================================================================
Type IWICBitmapDecoderInfoVtbl As IWICBitmapDecoderInfoVtbl_
Type IWICBitmapDecoderInfo
    lpVtbl As IWICBitmapDecoderInfoVtbl Ptr
End Type
Type IWICBitmapDecoderInfoVtbl_     '' Extends IWICBitmapCodecInfoVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapDecoderInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapDecoderInfo Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapDecoderInfo Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 4-11.  IWICComponentInfo
        ' 12. GetContainerFormat
    GetContainerFormat As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 13. GetPixelFormats
    GetPixelFormats As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cFormats As ULong, ByVal pguidPixelFormats As GUID Ptr, ByVal pcActual As ULong Ptr ) As HRESULT
        ' 14. GetColorManagementVersion
    GetColorManagementVersion As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchColorManagementVersion As ULong, ByVal wzColorManagementVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 15. GetDeviceManufacturer
    GetDeviceManufacturer As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchDeviceManufacturer As ULong, ByVal wzDeviceManufacturer As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 16. GetDeviceModels
    GetDeviceModels As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchDeviceModels As ULong, ByVal wzDeviceModels As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 17. GetMimeTypes
    GetMimeTypes As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchMimeTypes As ULong, ByVal wzMimeTypes As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 18. GetFileExtensions
    GetFileExtensions As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cchFileExtensions As ULong, ByVal wzFileExtensions As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 19. DoesSupportAnimation
    DoesSupportAnimation As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pfSupportAnimation As Long Ptr ) As HRESULT
        ' 20. DoesSupportChromakey
    DoesSupportChromakey As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pfSupportChromakey As Long Ptr ) As HRESULT
        ' 21. DoesSupportLossless
    DoesSupportLossless As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pfSupportLossless As Long Ptr ) As HRESULT
        ' 22. DoesSupportMultiframe
    DoesSupportMultiframe As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pfSupportMultiframe As Long Ptr ) As HRESULT
        ' 23. MatchesMimeType
    MatchesMimeType As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal wzMimeType As WString Ptr, ByVal pfMatches As Long Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
    
    GetPatterns As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal cbSizeAutoRuntime As ULong, ByVal pPatterns As Any Ptr, ByVal pcPatterns As ULong Ptr, ByVal pcbPatternsActual As ULong Ptr ) As HRESULT
        ' 25. MatchesPattern
    MatchesPattern As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal pIStream As Any Ptr, ByVal pfMatches As Long Ptr ) As HRESULT
        ' 26. CreateInstance
    CreateInstance As Function(ByVal This As IWICBitmapDecoderInfo Ptr,  ByVal ppIBitmapDecoder As Any Ptr Ptr ) As HRESULT
End Type
#define IWICBitmapDecoderInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapDecoderInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapDecoderInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapDecoderInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICBitmapDecoderInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICBitmapDecoderInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICBitmapDecoderInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICBitmapDecoderInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICBitmapDecoderInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICBitmapDecoderInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICBitmapDecoderInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICBitmapDecoderInfo_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICBitmapDecoderInfo_GetPixelFormats(p, a, b, c) (p)->lpVtbl->GetPixelFormats(p, a, b, c)
#define IWICBitmapDecoderInfo_GetColorManagementVersion(p, a, b, c) (p)->lpVtbl->GetColorManagementVersion(p, a, b, c)
#define IWICBitmapDecoderInfo_GetDeviceManufacturer(p, a, b, c) (p)->lpVtbl->GetDeviceManufacturer(p, a, b, c)
#define IWICBitmapDecoderInfo_GetDeviceModels(p, a, b, c) (p)->lpVtbl->GetDeviceModels(p, a, b, c)
#define IWICBitmapDecoderInfo_GetMimeTypes(p, a, b, c) (p)->lpVtbl->GetMimeTypes(p, a, b, c)
#define IWICBitmapDecoderInfo_GetFileExtensions(p, a, b, c) (p)->lpVtbl->GetFileExtensions(p, a, b, c)
#define IWICBitmapDecoderInfo_DoesSupportAnimation(p, a) (p)->lpVtbl->DoesSupportAnimation(p, a)
#define IWICBitmapDecoderInfo_DoesSupportChromakey(p, a) (p)->lpVtbl->DoesSupportChromakey(p, a)
#define IWICBitmapDecoderInfo_DoesSupportLossless(p, a) (p)->lpVtbl->DoesSupportLossless(p, a)
#define IWICBitmapDecoderInfo_DoesSupportMultiframe(p, a) (p)->lpVtbl->DoesSupportMultiframe(p, a)
#define IWICBitmapDecoderInfo_MatchesMimeType(p, a, b) (p)->lpVtbl->MatchesMimeType(p, a, b)
#define IWICBitmapDecoderInfo_GetPatterns(p, a, b, c, d) (p)->lpVtbl->GetPatterns(p, a, b, c, d)
#define IWICBitmapDecoderInfo_MatchesPattern(p, a, b) (p)->lpVtbl->MatchesPattern(p, a, b)
#define IWICBitmapDecoderInfo_CreateInstance(p, a) (p)->lpVtbl->CreateInstance(p, a)

' ============================================================================
' IWICBitmapDecoder
' ============================================================================
Type IWICBitmapDecoderVtbl As IWICBitmapDecoderVtbl_
Type IWICBitmapDecoder
    lpVtbl As IWICBitmapDecoderVtbl Ptr
End Type
Type IWICBitmapDecoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapDecoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapDecoder Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapDecoder Ptr) As ULong

    
    QueryCapability As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal pIStream As Any Ptr, ByVal pdwCapability As ULong Ptr ) As HRESULT
        ' 5. Initialize
    Initialize As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal pIStream As Any Ptr, ByVal cacheOptions As ULong ) As HRESULT
        ' 6. GetContainerFormat
    GetContainerFormat As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 7. GetDecoderInfo
    GetDecoderInfo As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal ppIDecoderInfo As Any Ptr Ptr ) As HRESULT
        ' 8. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 9. GetMetadataQueryReader
    GetMetadataQueryReader As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal ppIMetadataQueryReader As Any Ptr Ptr ) As HRESULT
        ' 10. GetPreview
    GetPreview As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal ppIBitmapSource As Any Ptr Ptr ) As HRESULT
        ' 11. GetColorContexts
    GetColorContexts As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal cCount As ULong, ByVal ppIColorContexts As Any Ptr Ptr, ByVal pcActualCount As ULong Ptr ) As HRESULT
        ' 12. GetThumbnail
    GetThumbnail As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal ppIThumbnail As Any Ptr Ptr ) As HRESULT
        ' 13. GetFrameCount
    GetFrameCount As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal pCount As ULong Ptr ) As HRESULT
        ' 14. GetFrame
    GetFrame As Function(ByVal This As IWICBitmapDecoder Ptr,  ByVal index As ULong, ByVal ppIBitmapFrame As Any Ptr Ptr ) As HRESULT
End Type
#define IWICBitmapDecoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapDecoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapDecoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapDecoder_QueryCapability(p, a, b) (p)->lpVtbl->QueryCapability(p, a, b)
#define IWICBitmapDecoder_Initialize(p, a, b) (p)->lpVtbl->Initialize(p, a, b)
#define IWICBitmapDecoder_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICBitmapDecoder_GetDecoderInfo(p, a) (p)->lpVtbl->GetDecoderInfo(p, a)
#define IWICBitmapDecoder_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapDecoder_GetMetadataQueryReader(p, a) (p)->lpVtbl->GetMetadataQueryReader(p, a)
#define IWICBitmapDecoder_GetPreview(p, a) (p)->lpVtbl->GetPreview(p, a)
#define IWICBitmapDecoder_GetColorContexts(p, a, b, c) (p)->lpVtbl->GetColorContexts(p, a, b, c)
#define IWICBitmapDecoder_GetThumbnail(p, a) (p)->lpVtbl->GetThumbnail(p, a)
#define IWICBitmapDecoder_GetFrameCount(p, a) (p)->lpVtbl->GetFrameCount(p, a)
#define IWICBitmapDecoder_GetFrame(p, a, b) (p)->lpVtbl->GetFrame(p, a, b)

' ============================================================================
' IWICBitmapFrameEncode
' ============================================================================
Type IWICBitmapFrameEncodeVtbl As IWICBitmapFrameEncodeVtbl_
Type IWICBitmapFrameEncode
    lpVtbl As IWICBitmapFrameEncodeVtbl Ptr
End Type
Type IWICBitmapFrameEncodeVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapFrameEncode Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapFrameEncode Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapFrameEncode Ptr) As ULong

    
    Initialize As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal pIEncoderOptions As Any Ptr ) As HRESULT
        ' 5. SetSize
    SetSize As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal uiWidth As ULong, ByVal uiHeight As ULong ) As HRESULT
        ' 6. SetResolution
    SetResolution As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal dpiX As Double, ByVal dpiY As Double ) As HRESULT
        ' 7. SetPixelFormat - ACHTUNG: Hier ist ByRef korrekt (REFGUID)!
    SetPixelFormat As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByRef pPixelFormat As GUID ) As HRESULT
        ' 8. SetColorContexts
    SetColorContexts As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal cCount As ULong, ByVal ppIColorContexts As Any Ptr Ptr ) As HRESULT
        ' 9. SetPalette
    SetPalette As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 10. SetThumbnail
    SetThumbnail As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal pIThumbnail As Any Ptr ) As HRESULT
        ' 11. WritePixels
    WritePixels As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal lineCount As ULong, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbPixels As UByte Ptr ) As HRESULT
        ' 12. WriteSource
    WriteSource As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal pIWICBitmapSource As Any Ptr, ByVal prc As Any Ptr ) As HRESULT
        ' 13. Commit
    Commit As Function(ByVal This As IWICBitmapFrameEncode Ptr) As HRESULT
        ' 14. GetMetadataQueryWriter
    GetMetadataQueryWriter As Function(ByVal This As IWICBitmapFrameEncode Ptr,  ByVal ppIMetadataQueryWriter As Any Ptr Ptr ) As HRESULT
End Type
#define IWICBitmapFrameEncode_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapFrameEncode_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapFrameEncode_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapFrameEncode_Initialize(p, a) (p)->lpVtbl->Initialize(p, a)
#define IWICBitmapFrameEncode_SetSize(p, a, b) (p)->lpVtbl->SetSize(p, a, b)
#define IWICBitmapFrameEncode_SetResolution(p, a, b) (p)->lpVtbl->SetResolution(p, a, b)
#define IWICBitmapFrameEncode_SetPixelFormat(p, a) (p)->lpVtbl->SetPixelFormat(p, a)
#define IWICBitmapFrameEncode_SetColorContexts(p, a, b) (p)->lpVtbl->SetColorContexts(p, a, b)
#define IWICBitmapFrameEncode_SetPalette(p, a) (p)->lpVtbl->SetPalette(p, a)
#define IWICBitmapFrameEncode_SetThumbnail(p, a) (p)->lpVtbl->SetThumbnail(p, a)
#define IWICBitmapFrameEncode_WritePixels(p, a, b, c, d) (p)->lpVtbl->WritePixels(p, a, b, c, d)
#define IWICBitmapFrameEncode_WriteSource(p, a, b) (p)->lpVtbl->WriteSource(p, a, b)
#define IWICBitmapFrameEncode_Commit(p, a) (p)->lpVtbl->Commit(p, a)
#define IWICBitmapFrameEncode_GetMetadataQueryWriter(p, a) (p)->lpVtbl->GetMetadataQueryWriter(p, a)

' ============================================================================
' IWICBitmapEncoderInfo
' ============================================================================
Type IWICBitmapEncoderInfoVtbl As IWICBitmapEncoderInfoVtbl_
Type IWICBitmapEncoderInfo
    lpVtbl As IWICBitmapEncoderInfoVtbl Ptr
End Type
Type IWICBitmapEncoderInfoVtbl_     '' Extends IWICBitmapCodecInfoVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapEncoderInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapEncoderInfo Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapEncoderInfo Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 4-11.  IWICComponentInfo
        ' 12. GetContainerFormat
    GetContainerFormat As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 13. GetPixelFormats
    GetPixelFormats As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cFormats As ULong, ByVal pguidPixelFormats As GUID Ptr, ByVal pcActual As ULong Ptr ) As HRESULT
        ' 14. GetColorManagementVersion
    GetColorManagementVersion As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchColorManagementVersion As ULong, ByVal wzColorManagementVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 15. GetDeviceManufacturer
    GetDeviceManufacturer As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchDeviceManufacturer As ULong, ByVal wzDeviceManufacturer As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 16. GetDeviceModels
    GetDeviceModels As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchDeviceModels As ULong, ByVal wzDeviceModels As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 17. GetMimeTypes
    GetMimeTypes As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchMimeTypes As ULong, ByVal wzMimeTypes As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 18. GetFileExtensions
    GetFileExtensions As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal cchFileExtensions As ULong, ByVal wzFileExtensions As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 19. DoesSupportAnimation
    DoesSupportAnimation As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportAnimation As Long Ptr ) As HRESULT
        ' 20. DoesSupportChromakey
    DoesSupportChromakey As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportChromakey As Long Ptr ) As HRESULT
        ' 21. DoesSupportLossless
    DoesSupportLossless As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportLossless As Long Ptr ) As HRESULT
        ' 22. DoesSupportMultiframe
    DoesSupportMultiframe As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportMultiframe As Long Ptr ) As HRESULT
        ' 23. MatchesMimeType
    MatchesMimeType As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal wzMimeType As WString Ptr, ByVal pfMatches As Long Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
    
    CreateInstance As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal ppIBitmapEncoder As Any Ptr Ptr ) As HRESULT
        ' 25. DoesSupportPreview
    DoesSupportPreview As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportPreview As Long Ptr ) As HRESULT
        ' 26. DoesSupportThumbnail
    DoesSupportThumbnail As Function(ByVal This As IWICBitmapEncoderInfo Ptr,  ByVal pfSupportThumbnail As Long Ptr ) As HRESULT
End Type
#define IWICBitmapEncoderInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapEncoderInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapEncoderInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapEncoderInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICBitmapEncoderInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICBitmapEncoderInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICBitmapEncoderInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICBitmapEncoderInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICBitmapEncoderInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICBitmapEncoderInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICBitmapEncoderInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICBitmapEncoderInfo_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICBitmapEncoderInfo_GetPixelFormats(p, a, b, c) (p)->lpVtbl->GetPixelFormats(p, a, b, c)
#define IWICBitmapEncoderInfo_GetColorManagementVersion(p, a, b, c) (p)->lpVtbl->GetColorManagementVersion(p, a, b, c)
#define IWICBitmapEncoderInfo_GetDeviceManufacturer(p, a, b, c) (p)->lpVtbl->GetDeviceManufacturer(p, a, b, c)
#define IWICBitmapEncoderInfo_GetDeviceModels(p, a, b, c) (p)->lpVtbl->GetDeviceModels(p, a, b, c)
#define IWICBitmapEncoderInfo_GetMimeTypes(p, a, b, c) (p)->lpVtbl->GetMimeTypes(p, a, b, c)
#define IWICBitmapEncoderInfo_GetFileExtensions(p, a, b, c) (p)->lpVtbl->GetFileExtensions(p, a, b, c)
#define IWICBitmapEncoderInfo_DoesSupportAnimation(p, a) (p)->lpVtbl->DoesSupportAnimation(p, a)
#define IWICBitmapEncoderInfo_DoesSupportChromakey(p, a) (p)->lpVtbl->DoesSupportChromakey(p, a)
#define IWICBitmapEncoderInfo_DoesSupportLossless(p, a) (p)->lpVtbl->DoesSupportLossless(p, a)
#define IWICBitmapEncoderInfo_DoesSupportMultiframe(p, a) (p)->lpVtbl->DoesSupportMultiframe(p, a)
#define IWICBitmapEncoderInfo_MatchesMimeType(p, a, b) (p)->lpVtbl->MatchesMimeType(p, a, b)
#define IWICBitmapEncoderInfo_CreateInstance(p, a) (p)->lpVtbl->CreateInstance(p, a)
#define IWICBitmapEncoderInfo_DoesSupportPreview(p, a) (p)->lpVtbl->DoesSupportPreview(p, a)
#define IWICBitmapEncoderInfo_DoesSupportThumbnail(p, a) (p)->lpVtbl->DoesSupportThumbnail(p, a)

' ============================================================================
' IWICBitmapEncoder
' ============================================================================
Type IWICBitmapEncoderVtbl As IWICBitmapEncoderVtbl_
Type IWICBitmapEncoder
    lpVtbl As IWICBitmapEncoderVtbl Ptr
End Type
Type IWICBitmapEncoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapEncoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapEncoder Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapEncoder Ptr) As ULong

    
    Initialize As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal pIStream As Any Ptr, ByVal cacheOptions As ULong ) As HRESULT
        ' 5. GetContainerFormat
    GetContainerFormat As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal pguidContainerFormat As GUID Ptr ) As HRESULT
        ' 6. GetEncoderInfo
    GetEncoderInfo As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal ppIEncoderInfo As Any Ptr Ptr ) As HRESULT
        ' 7. SetColorContexts
    SetColorContexts As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal cCount As ULong, ByVal ppIColorContexts As Any Ptr Ptr ) As HRESULT
        ' 8. SetPalette
    SetPalette As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 9. SetThumbnail
    SetThumbnail As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal pIThumbnail As Any Ptr ) As HRESULT
        ' 10. SetPreview
    SetPreview As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal pIPreview As Any Ptr ) As HRESULT
        ' 11. CreateNewFrame
    CreateNewFrame As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal ppIFrameEncode As Any Ptr Ptr, ByVal ppIEncoderOptions As Any Ptr Ptr ) As HRESULT
        ' 12. Commit
    Commit As Function(ByVal This As IWICBitmapEncoder Ptr) As HRESULT
        ' 13. GetMetadataQueryWriter
    GetMetadataQueryWriter As Function(ByVal This As IWICBitmapEncoder Ptr,  ByVal ppIMetadataQueryWriter As Any Ptr Ptr ) As HRESULT
End Type
#define IWICBitmapEncoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapEncoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapEncoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapEncoder_Initialize(p, a, b) (p)->lpVtbl->Initialize(p, a, b)
#define IWICBitmapEncoder_GetContainerFormat(p, a) (p)->lpVtbl->GetContainerFormat(p, a)
#define IWICBitmapEncoder_GetEncoderInfo(p, a) (p)->lpVtbl->GetEncoderInfo(p, a)
#define IWICBitmapEncoder_SetColorContexts(p, a, b) (p)->lpVtbl->SetColorContexts(p, a, b)
#define IWICBitmapEncoder_SetPalette(p, a) (p)->lpVtbl->SetPalette(p, a)
#define IWICBitmapEncoder_SetThumbnail(p, a) (p)->lpVtbl->SetThumbnail(p, a)
#define IWICBitmapEncoder_SetPreview(p, a) (p)->lpVtbl->SetPreview(p, a)
#define IWICBitmapEncoder_CreateNewFrame(p, a, b) (p)->lpVtbl->CreateNewFrame(p, a, b)
#define IWICBitmapEncoder_Commit(p, a) (p)->lpVtbl->Commit(p, a)
#define IWICBitmapEncoder_GetMetadataQueryWriter(p, a) (p)->lpVtbl->GetMetadataQueryWriter(p, a)

' ============================================================================
' IWICFormatConverter
' ============================================================================
Type IWICFormatConverterVtbl As IWICFormatConverterVtbl_
Type IWICFormatConverter
    lpVtbl As IWICFormatConverterVtbl Ptr
End Type
Type IWICFormatConverterVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICFormatConverter Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICFormatConverter Ptr) As ULong
    Release As Function(ByVal This As IWICFormatConverter Ptr) As ULong
    GetSize As Function(ByVal This As IWICFormatConverter Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICFormatConverter Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICFormatConverter Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICFormatConverter Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICFormatConverter Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

    Initialize As Function(ByVal This As IWICFormatConverter Ptr,  ByVal pISource As IWICBitmapSource Ptr, ByVal dstFormat As GUID Ptr, ByVal dither As WICBitmapDitherType, ByVal pIPalette As Any Ptr, ByVal alphaThresholdPercent As Double, ByVal paletteTranslate As WICBitmapPaletteType ) As HRESULT
        ' 10. CanConvert - ACHTUNG: srcFormat und dstFormat bleiben ByRef (REFGUID)!
    CanConvert As Function(ByVal This As IWICFormatConverter Ptr,  ByVal srcFormat As GUID Ptr, ByVal dstFormat As GUID Ptr, ByVal pfCanConvert As Long Ptr ) As HRESULT
End Type
#define IWICFormatConverter_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICFormatConverter_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICFormatConverter_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICFormatConverter_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICFormatConverter_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICFormatConverter_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICFormatConverter_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICFormatConverter_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICFormatConverter_Initialize(p, a, b, c, d, e, f) (p)->lpVtbl->Initialize(p, a, b, c, d, e, f)
#define IWICFormatConverter_CanConvert(p, a, b, c) (p)->lpVtbl->CanConvert(p, a, b, c)

' ============================================================================
' IWICFormatConverterInfo
' ============================================================================
Type IWICFormatConverterInfoVtbl As IWICFormatConverterInfoVtbl_
Type IWICFormatConverterInfo
    lpVtbl As IWICFormatConverterInfoVtbl Ptr
End Type
Type IWICFormatConverterInfoVtbl_     '' Extends IWICComponentInfoVtbl_
    QueryInterface As Function(ByVal This As IWICFormatConverterInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICFormatConverterInfo Ptr) As ULong
    Release As Function(ByVal This As IWICFormatConverterInfo Ptr) As ULong
        
    GetComponentType As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal pType As ULong Ptr ) As HRESULT
        ' 5. GetCLSID
    GetCLSID As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal pclsid As GUID Ptr ) As HRESULT
        ' 6. GetSigningStatus
    GetSigningStatus As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal pStatus As ULong Ptr ) As HRESULT
        ' 7. GetAuthor
    GetAuthor As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal cchAuthor As ULong, ByVal wzAuthor As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 8. GetVendorGUID
    GetVendorGUID As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal pguidVendor As GUID Ptr ) As HRESULT
        ' 9. GetVersion
    GetVersion As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal cchVersion As ULong, ByVal wzVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 10. GetSpecVersion
    GetSpecVersion As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal cchSpecVersion As ULong, ByVal wzSpecVersion As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT
        ' 11. GetFriendlyName
    GetFriendlyName As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal cchFriendlyName As ULong, ByVal wzFriendlyName As WString Ptr, ByVal pcchActual As ULong Ptr ) As HRESULT

        ' 4-11.  IWICComponentInfo
        ' 12. GetPixelFormats
    GetPixelFormats As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal cFormats As ULong, ByVal pPixelFormatGUIDs As GUID Ptr, ByVal pcActual As ULong Ptr ) As HRESULT
        ' 13. CreateInstance
    CreateInstance As Function(ByVal This As IWICFormatConverterInfo Ptr,  ByVal ppIConverter As Any Ptr Ptr ) As HRESULT
End Type
#define IWICFormatConverterInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICFormatConverterInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICFormatConverterInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICFormatConverterInfo_GetComponentType(p, a) (p)->lpVtbl->GetComponentType(p, a)
#define IWICFormatConverterInfo_GetCLSID(p, a) (p)->lpVtbl->GetCLSID(p, a)
#define IWICFormatConverterInfo_GetSigningStatus(p, a) (p)->lpVtbl->GetSigningStatus(p, a)
#define IWICFormatConverterInfo_GetAuthor(p, a, b, c) (p)->lpVtbl->GetAuthor(p, a, b, c)
#define IWICFormatConverterInfo_GetVendorGUID(p, a) (p)->lpVtbl->GetVendorGUID(p, a)
#define IWICFormatConverterInfo_GetVersion(p, a, b, c) (p)->lpVtbl->GetVersion(p, a, b, c)
#define IWICFormatConverterInfo_GetSpecVersion(p, a, b, c) (p)->lpVtbl->GetSpecVersion(p, a, b, c)
#define IWICFormatConverterInfo_GetFriendlyName(p, a, b, c) (p)->lpVtbl->GetFriendlyName(p, a, b, c)
#define IWICFormatConverterInfo_GetPixelFormats(p, a, b, c) (p)->lpVtbl->GetPixelFormats(p, a, b, c)
#define IWICFormatConverterInfo_CreateInstance(p, a) (p)->lpVtbl->CreateInstance(p, a)

' ============================================================================
' IWICStream
' ============================================================================
Type IWICStreamVtbl As IWICStreamVtbl_
Type IWICStream
    lpVtbl As IWICStreamVtbl Ptr
End Type
Type IWICStreamVtbl_     '' Extends IStreamWICVtbl_
    QueryInterface As Function(ByVal This As IWICStream Ptr, ByVal riid As Any Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICStream Ptr) As ULong
    Release As Function(ByVal This As IWICStream Ptr) As ULong
    Read As Function(ByVal This As IWICStream Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbRead As ULong Ptr) As HRESULT
    Write As Function(ByVal This As IWICStream Ptr, ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbWritten As ULong Ptr) As HRESULT
    Seek As Function(ByVal This As IWICStream Ptr, ByVal dlibMove As LongInt, ByVal dwOrigin As ULong, ByVal plibNewPosition As LongInt Ptr) As HRESULT
    SetSize As Function(ByVal This As IWICStream Ptr, ByVal libNewSize As LongInt) As HRESULT
    CopyTo As Function(ByVal This As IWICStream Ptr, ByVal pstm As IWICStream Ptr, ByVal cb As LongInt, ByVal pcbRead As LongInt Ptr, ByVal pcbWritten As LongInt Ptr) As HRESULT
    Commit As Function(ByVal This As IWICStream Ptr, ByVal grfCommitFlags As ULong) As HRESULT
    Revert As Function(ByVal This As IWICStream Ptr) As HRESULT
    LockRegion As Function(ByVal This As IWICStream Ptr, ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    UnlockRegion As Function(ByVal This As IWICStream Ptr, ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    Stat As Function(ByVal This As IWICStream Ptr, ByVal pstatstg As Any Ptr, ByVal grfStatFlag As ULong) As HRESULT
    Clone As Function(ByVal This As IWICStream Ptr, ByVal ppstm As IWICStream Ptr Ptr) As HRESULT

        ' 4-5.   ISequentialStream
    
    InitializeFromIStream As Function(ByVal This As IWICStream Ptr,  ByVal pIStream As Any Ptr ) As HRESULT
        ' 16. InitializeFromFilename
    InitializeFromFilename As Function(ByVal This As IWICStream Ptr,  ByVal wzFileName As WString Ptr, ByVal dwDesiredAccess As ULong ) As HRESULT
        ' 17. InitializeFromMemory
    InitializeFromMemory As Function(ByVal This As IWICStream Ptr,  ByVal pbBuffer As UByte Ptr, ByVal cbBufferSize As ULong ) As HRESULT
        ' 18. InitializeFromIStreamRegion
    InitializeFromIStreamRegion As Function(ByVal This As IWICStream Ptr,  ByVal pIStream As Any Ptr, ByVal ulOffset As ULARGE_INTEGER, ByVal ulMaxSize As ULARGE_INTEGER ) As HRESULT
End Type
#define IWICStream_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICStream_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICStream_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICStream_Read(p, a, b, c) (p)->lpVtbl->Read(p, a, b, c)
#define IWICStream_Write(p, a, b, c) (p)->lpVtbl->Write(p, a, b, c)
#define IWICStream_Seek(p, a, b, c) (p)->lpVtbl->Seek(p, a, b, c)
#define IWICStream_SetSize(p, a) (p)->lpVtbl->SetSize(p, a)
#define IWICStream_CopyTo(p, a, b, c, d) (p)->lpVtbl->CopyTo(p, a, b, c, d)
#define IWICStream_Commit(p, a) (p)->lpVtbl->Commit(p, a)
#define IWICStream_Revert(p, a) (p)->lpVtbl->Revert(p, a)
#define IWICStream_LockRegion(p, a, b, c) (p)->lpVtbl->LockRegion(p, a, b, c)
#define IWICStream_UnlockRegion(p, a, b, c) (p)->lpVtbl->UnlockRegion(p, a, b, c)
#define IWICStream_Stat(p, a, b) (p)->lpVtbl->Stat(p, a, b)
#define IWICStream_Clone(p, a) (p)->lpVtbl->Clone(p, a)
#define IWICStream_InitializeFromIStream(p, a) (p)->lpVtbl->InitializeFromIStream(p, a)
#define IWICStream_InitializeFromFilename(p, a, b) (p)->lpVtbl->InitializeFromFilename(p, a, b)
#define IWICStream_InitializeFromMemory(p, a, b) (p)->lpVtbl->InitializeFromMemory(p, a, b)
#define IWICStream_InitializeFromIStreamRegion(p, a, b, c) (p)->lpVtbl->InitializeFromIStreamRegion(p, a, b, c)

' ============================================================================
' IWICBitmapScaler
' ============================================================================
Type IWICBitmapScalerVtbl As IWICBitmapScalerVtbl_
Type IWICBitmapScaler
    lpVtbl As IWICBitmapScalerVtbl Ptr
End Type
Type IWICBitmapScalerVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapScaler Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapScaler Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapScaler Ptr) As ULong
    GetSize As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource
        ' 9. Initialize
    Initialize As Function(ByVal This As IWICBitmapScaler Ptr,  ByVal pISource As IWICBitmapSource Ptr, ByVal uiWidth As ULong, ByVal uiHeight As ULong, ByVal mode As WICBitmapInterpolationMode ) As HRESULT
End Type
#define IWICBitmapScaler_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapScaler_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapScaler_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapScaler_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapScaler_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmapScaler_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmapScaler_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapScaler_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICBitmapScaler_Initialize(p, a, b, c, d) (p)->lpVtbl->Initialize(p, a, b, c, d)

' ============================================================================
' IWICBitmapClipper
' ============================================================================
Type IWICBitmapClipperVtbl As IWICBitmapClipperVtbl_
Type IWICBitmapClipper
    lpVtbl As IWICBitmapClipperVtbl Ptr
End Type
Type IWICBitmapClipperVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICBitmapClipper Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmapClipper Ptr) As ULong
    Release As Function(ByVal This As IWICBitmapClipper Ptr) As ULong
    GetSize As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource
        ' 9. Initialize
    Initialize As Function(ByVal This As IWICBitmapClipper Ptr,  ByVal pISource As IWICBitmapSource Ptr, ByVal pRect As WICRect Ptr ) As HRESULT
End Type
#define IWICBitmapClipper_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICBitmapClipper_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICBitmapClipper_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICBitmapClipper_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICBitmapClipper_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICBitmapClipper_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICBitmapClipper_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICBitmapClipper_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICBitmapClipper_Initialize(p, a, b) (p)->lpVtbl->Initialize(p, a, b)

' ============================================================================
' IWICColorTransform
' ============================================================================
Type IWICColorTransformVtbl As IWICColorTransformVtbl_
Type IWICColorTransform
    lpVtbl As IWICColorTransformVtbl Ptr
End Type
Type IWICColorTransformVtbl_     '' Extends IWICBitmapSourceVtbl_
    QueryInterface As Function(ByVal This As IWICColorTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICColorTransform Ptr) As ULong
    Release As Function(ByVal This As IWICColorTransform Ptr) As ULong
    GetSize As Function(ByVal This As IWICColorTransform Ptr,  ByVal puiWidth As ULong Ptr, ByVal puiHeight As ULong Ptr ) As HRESULT
        ' 5. GetPixelFormat - OUT-Parameter als Pointer
    GetPixelFormat As Function(ByVal This As IWICColorTransform Ptr,  ByVal pPixelFormat As GUID Ptr ) As HRESULT
        ' 6. GetResolution - OUT-Parameter als Pointer
    GetResolution As Function(ByVal This As IWICColorTransform Ptr,  ByVal pDpiX As Double Ptr, ByVal pDpiY As Double Ptr ) As HRESULT
        ' 7. CopyPalette
    CopyPalette As Function(ByVal This As IWICColorTransform Ptr,  ByVal pIPalette As Any Ptr ) As HRESULT
        ' 8. CopyPixels
    CopyPixels As Function(ByVal This As IWICColorTransform Ptr,  ByVal prc As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT

        ' 4-8. IWICBitmapSource
        ' 9. Initialize - ACHTUNG: pixelFormatDest bleibt ByRef (REFGUID)!
    Initialize As Function(ByVal This As IWICColorTransform Ptr,  ByVal pIBitmapSource As IWICBitmapSource Ptr, ByVal pIContextSource As Any Ptr, ByVal pIContextDest As Any Ptr, ByRef pixelFormatDest As GUID ) As HRESULT
End Type
#define IWICColorTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICColorTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICColorTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICColorTransform_GetSize(p, a, b) (p)->lpVtbl->GetSize(p, a, b)
#define IWICColorTransform_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define IWICColorTransform_GetResolution(p, a, b) (p)->lpVtbl->GetResolution(p, a, b)
#define IWICColorTransform_CopyPalette(p, a) (p)->lpVtbl->CopyPalette(p, a)
#define IWICColorTransform_CopyPixels(p, a, b, c, d) (p)->lpVtbl->CopyPixels(p, a, b, c, d)
#define IWICColorTransform_Initialize(p, a, b, c, d) (p)->lpVtbl->Initialize(p, a, b, c, d)

' ============================================================================
' IWICFastMetadataEncoder
' ============================================================================
Type IWICFastMetadataEncoderVtbl As IWICFastMetadataEncoderVtbl_
Type IWICFastMetadataEncoder
    lpVtbl As IWICFastMetadataEncoderVtbl Ptr
End Type
Type IWICFastMetadataEncoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICFastMetadataEncoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICFastMetadataEncoder Ptr) As ULong
    Release As Function(ByVal This As IWICFastMetadataEncoder Ptr) As ULong

    
    Commit As Function(ByVal This As IWICFastMetadataEncoder Ptr) As HRESULT
        ' 5. GetMetadataQueryWriter
    GetMetadataQueryWriter As Function(ByVal This As IWICFastMetadataEncoder Ptr,  ByVal ppIMetadataQueryWriter As Any Ptr Ptr ) As HRESULT
End Type
#define IWICFastMetadataEncoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICFastMetadataEncoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICFastMetadataEncoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICFastMetadataEncoder_Commit(p, a) (p)->lpVtbl->Commit(p, a)
#define IWICFastMetadataEncoder_GetMetadataQueryWriter(p, a) (p)->lpVtbl->GetMetadataQueryWriter(p, a)

' ============================================================================
' IWICImageEncoder
' ============================================================================
Type IWICImageEncoderVtbl As IWICImageEncoderVtbl_
Type IWICImageEncoder
    lpVtbl As IWICImageEncoderVtbl Ptr
End Type
Type IWICImageEncoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICImageEncoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICImageEncoder Ptr) As ULong
    Release As Function(ByVal This As IWICImageEncoder Ptr) As ULong

    
    WriteFrame As Function(ByVal This As IWICImageEncoder Ptr,  ByVal pImage As Any Ptr, ByVal pFrameEncode As Any Ptr, ByVal pImageParameters As Any Ptr ) As HRESULT
        ' 5. WriteFrameThumbnail
    WriteFrameThumbnail As Function(ByVal This As IWICImageEncoder Ptr,  ByVal pImage As Any Ptr, ByVal pFrameEncode As Any Ptr, ByVal pImageParameters As Any Ptr ) As HRESULT
        ' 6. WriteThumbnail
    WriteThumbnail As Function(ByVal This As IWICImageEncoder Ptr,  ByVal pImage As Any Ptr, ByVal pEncoder As Any Ptr, ByVal pImageParameters As Any Ptr ) As HRESULT
End Type
#define IWICImageEncoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICImageEncoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICImageEncoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICImageEncoder_WriteFrame(p, a, b, c) (p)->lpVtbl->WriteFrame(p, a, b, c)
#define IWICImageEncoder_WriteFrameThumbnail(p, a, b, c) (p)->lpVtbl->WriteFrameThumbnail(p, a, b, c)
#define IWICImageEncoder_WriteThumbnail(p, a, b, c) (p)->lpVtbl->WriteThumbnail(p, a, b, c)

' ============================================================================
' IWICImagingFactory
' ============================================================================
Type IWICImagingFactoryVtbl As IWICImagingFactoryVtbl_
Type IWICImagingFactory
    lpVtbl As IWICImagingFactoryVtbl Ptr
End Type
Type IWICImagingFactoryVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICImagingFactory Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICImagingFactory Ptr) As ULong
    Release As Function(ByVal This As IWICImagingFactory Ptr) As ULong

    CreateDecoderFromFilename As Function(ByVal This As IWICImagingFactory Ptr,  ByVal wzFilename As WString Ptr, ByVal pguidVendor As GUID Ptr, ByVal dwDesiredAccess As ULong, ByVal metadataOptions As ULong, ByVal ppIDecoder As IWICBitmapDecoder Ptr Ptr ) As HRESULT
        ' 5. CreateDecoderFromStream
    CreateDecoderFromStream As Function(ByVal This As IWICImagingFactory Ptr,  ByVal pIStream As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal metadataOptions As ULong, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 6. CreateDecoderFromFileHandle
    CreateDecoderFromFileHandle As Function(ByVal This As IWICImagingFactory Ptr,  ByVal hFile As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal metadataOptions As ULong, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 7. CreateComponentInfo
    CreateComponentInfo As Function(ByVal This As IWICImagingFactory Ptr,  ByRef clsidComponent As GUID, ByVal ppIInfo As Any Ptr Ptr ) As HRESULT
        ' 8. CreateDecoder
    CreateDecoder As Function(ByVal This As IWICImagingFactory Ptr,  ByRef guidContainerFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 9. CreateEncoder
    CreateEncoder As Function(ByVal This As IWICImagingFactory Ptr,  ByVal guidContainerFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIEncoder As IWICBitmapEncoder Ptr Ptr ) As HRESULT
        ' 10. CreatePalette
    CreatePalette As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIPalette As Any Ptr Ptr ) As HRESULT
        ' 11. CreateFormatConverter
    CreateFormatConverter As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIFormatConverter As Any Ptr Ptr ) As HRESULT
        ' 12. CreateBitmapScaler
    CreateBitmapScaler As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIBitmapScaler As Any Ptr Ptr ) As HRESULT
        ' 13. CreateBitmapClipper
    CreateBitmapClipper As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIBitmapClipper As Any Ptr Ptr ) As HRESULT
        ' 14. CreateBitmapFlipRotator
    CreateBitmapFlipRotator As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIBitmapFlipRotator As Any Ptr Ptr ) As HRESULT
        ' 15. CreateStream
    CreateStream As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIWICStream As Any Ptr Ptr ) As HRESULT
        ' 16. CreateColorContext
    CreateColorContext As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIWICColorContext As Any Ptr Ptr ) As HRESULT
        ' 17. CreateColorTransformer
    CreateColorTransformer As Function(ByVal This As IWICImagingFactory Ptr,  ByVal ppIWICColorTransform As Any Ptr Ptr ) As HRESULT
        ' 18. CreateBitmap - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    CreateBitmap As Function(ByVal This As IWICImagingFactory Ptr,  ByVal uiWidth As ULong, ByVal uiHeight As ULong, ByRef pixelFormat As GUID, ByVal option_ As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 19. CreateBitmapFromSource
    CreateBitmapFromSource As Function(ByVal This As IWICImagingFactory Ptr,  ByVal piBitmapSource As Any Ptr, ByVal option_ As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 20. CreateBitmapFromSourceRect
    CreateBitmapFromSourceRect As Function(ByVal This As IWICImagingFactory Ptr,  ByVal piBitmapSource As Any Ptr, ByVal x As ULong, ByVal y As ULong, ByVal width As ULong, ByVal height As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 21. CreateBitmapFromMemory - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    CreateBitmapFromMemory As Function(ByVal This As IWICImagingFactory Ptr,  ByVal uiWidth As ULong, ByVal uiHeight As ULong, ByRef pixelFormat As GUID, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 22. CreateBitmapFromHBITMAP
    CreateBitmapFromHBITMAP As Function(ByVal This As IWICImagingFactory Ptr,  ByVal hBitmap As Any Ptr, ByVal hPalette As Any Ptr, ByVal options As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 23. CreateBitmapFromHICON
    CreateBitmapFromHICON As Function(ByVal This As IWICImagingFactory Ptr,  ByVal hIcon As Any Ptr, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 24. CreateComponentEnumerator
    CreateComponentEnumerator As Function(ByVal This As IWICImagingFactory Ptr,  ByVal componentTypes As ULong, ByVal options As ULong, ByVal ppIEnumUnknown As Any Ptr Ptr ) As HRESULT
        ' 25. CreateFastMetadataEncoderFromDecoder
    CreateFastMetadataEncoderFromDecoder As Function(ByVal This As IWICImagingFactory Ptr,  ByVal pIDecoder As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr ) As HRESULT
        ' 26. CreateFastMetadataEncoderFromFrameDecode
    CreateFastMetadataEncoderFromFrameDecode As Function(ByVal This As IWICImagingFactory Ptr,  ByVal pIFrameDecoder As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr ) As HRESULT
        ' 27. CreateQueryWriter
    CreateQueryWriter As Function(ByVal This As IWICImagingFactory Ptr,  ByRef guidMetadataFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr ) As HRESULT
        ' 28. CreateQueryWriterFromReader
    CreateQueryWriterFromReader As Function(ByVal This As IWICImagingFactory Ptr,  ByVal pIQueryReader As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr ) As HRESULT
End Type
#define IWICImagingFactory_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICImagingFactory_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICImagingFactory_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICImagingFactory_CreateDecoderFromFilename(p, a, b, c, d, e) (p)->lpVtbl->CreateDecoderFromFilename(p, a, b, c, d, e)
#define IWICImagingFactory_CreateDecoderFromStream(p, a, b, c, d) (p)->lpVtbl->CreateDecoderFromStream(p, a, b, c, d)
#define IWICImagingFactory_CreateDecoderFromFileHandle(p, a, b, c, d) (p)->lpVtbl->CreateDecoderFromFileHandle(p, a, b, c, d)
#define IWICImagingFactory_CreateComponentInfo(p, a, b) (p)->lpVtbl->CreateComponentInfo(p, a, b)
#define IWICImagingFactory_CreateDecoder(p, a, b, c) (p)->lpVtbl->CreateDecoder(p, a, b, c)
#define IWICImagingFactory_CreateEncoder(p, a, b, c) (p)->lpVtbl->CreateEncoder(p, a, b, c)
#define IWICImagingFactory_CreatePalette(p, a) (p)->lpVtbl->CreatePalette(p, a)
#define IWICImagingFactory_CreateFormatConverter(p, a) (p)->lpVtbl->CreateFormatConverter(p, a)
#define IWICImagingFactory_CreateBitmapScaler(p, a) (p)->lpVtbl->CreateBitmapScaler(p, a)
#define IWICImagingFactory_CreateBitmapClipper(p, a) (p)->lpVtbl->CreateBitmapClipper(p, a)
#define IWICImagingFactory_CreateBitmapFlipRotator(p, a) (p)->lpVtbl->CreateBitmapFlipRotator(p, a)
#define IWICImagingFactory_CreateStream(p, a) (p)->lpVtbl->CreateStream(p, a)
#define IWICImagingFactory_CreateColorContext(p, a) (p)->lpVtbl->CreateColorContext(p, a)
#define IWICImagingFactory_CreateColorTransformer(p, a) (p)->lpVtbl->CreateColorTransformer(p, a)
#define IWICImagingFactory_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define IWICImagingFactory_CreateBitmapFromSource(p, a, b, c) (p)->lpVtbl->CreateBitmapFromSource(p, a, b, c)
#define IWICImagingFactory_CreateBitmapFromSourceRect(p, a, b, c, d, e, f) (p)->lpVtbl->CreateBitmapFromSourceRect(p, a, b, c, d, e, f)
#define IWICImagingFactory_CreateBitmapFromMemory(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateBitmapFromMemory(p, a, b, c, d, e, f, g)
#define IWICImagingFactory_CreateBitmapFromHBITMAP(p, a, b, c, d) (p)->lpVtbl->CreateBitmapFromHBITMAP(p, a, b, c, d)
#define IWICImagingFactory_CreateBitmapFromHICON(p, a, b) (p)->lpVtbl->CreateBitmapFromHICON(p, a, b)
#define IWICImagingFactory_CreateComponentEnumerator(p, a, b, c) (p)->lpVtbl->CreateComponentEnumerator(p, a, b, c)
#define IWICImagingFactory_CreateFastMetadataEncoderFromDecoder(p, a, b) (p)->lpVtbl->CreateFastMetadataEncoderFromDecoder(p, a, b)
#define IWICImagingFactory_CreateFastMetadataEncoderFromFrameDecode(p, a, b) (p)->lpVtbl->CreateFastMetadataEncoderFromFrameDecode(p, a, b)
#define IWICImagingFactory_CreateQueryWriter(p, a, b, c) (p)->lpVtbl->CreateQueryWriter(p, a, b, c)
#define IWICImagingFactory_CreateQueryWriterFromReader(p, a, b, c) (p)->lpVtbl->CreateQueryWriterFromReader(p, a, b, c)

' ============================================================================
' IWICImagingFactory2
' ============================================================================
Type IWICImagingFactory2Vtbl As IWICImagingFactory2Vtbl_
Type IWICImagingFactory2
    lpVtbl As IWICImagingFactory2Vtbl Ptr
End Type
Type IWICImagingFactory2Vtbl_     '' Extends IWICImagingFactoryVtbl_
    QueryInterface As Function(ByVal This As IWICImagingFactory2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICImagingFactory2 Ptr) As ULong
    Release As Function(ByVal This As IWICImagingFactory2 Ptr) As ULong
    CreateDecoderFromFilename As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal wzFilename As WString Ptr, ByVal pguidVendor As GUID Ptr, ByVal dwDesiredAccess As ULong, ByVal metadataOptions As ULong, ByVal ppIDecoder As IWICBitmapDecoder Ptr Ptr ) As HRESULT
        ' 5. CreateDecoderFromStream
    CreateDecoderFromStream As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pIStream As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal metadataOptions As ULong, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 6. CreateDecoderFromFileHandle
    CreateDecoderFromFileHandle As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal hFile As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal metadataOptions As ULong, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 7. CreateComponentInfo
    CreateComponentInfo As Function(ByVal This As IWICImagingFactory2 Ptr,  ByRef clsidComponent As GUID, ByVal ppIInfo As Any Ptr Ptr ) As HRESULT
        ' 8. CreateDecoder
    CreateDecoder As Function(ByVal This As IWICImagingFactory2 Ptr,  ByRef guidContainerFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIDecoder As Any Ptr Ptr ) As HRESULT
        ' 9. CreateEncoder
    CreateEncoder As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal guidContainerFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIEncoder As IWICBitmapEncoder Ptr Ptr ) As HRESULT
        ' 10. CreatePalette
    CreatePalette As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIPalette As Any Ptr Ptr ) As HRESULT
        ' 11. CreateFormatConverter
    CreateFormatConverter As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIFormatConverter As Any Ptr Ptr ) As HRESULT
        ' 12. CreateBitmapScaler
    CreateBitmapScaler As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIBitmapScaler As Any Ptr Ptr ) As HRESULT
        ' 13. CreateBitmapClipper
    CreateBitmapClipper As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIBitmapClipper As Any Ptr Ptr ) As HRESULT
        ' 14. CreateBitmapFlipRotator
    CreateBitmapFlipRotator As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIBitmapFlipRotator As Any Ptr Ptr ) As HRESULT
        ' 15. CreateStream
    CreateStream As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIWICStream As Any Ptr Ptr ) As HRESULT
        ' 16. CreateColorContext
    CreateColorContext As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIWICColorContext As Any Ptr Ptr ) As HRESULT
        ' 17. CreateColorTransformer
    CreateColorTransformer As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal ppIWICColorTransform As Any Ptr Ptr ) As HRESULT
        ' 18. CreateBitmap - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    CreateBitmap As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal uiWidth As ULong, ByVal uiHeight As ULong, ByRef pixelFormat As GUID, ByVal option_ As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 19. CreateBitmapFromSource
    CreateBitmapFromSource As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal piBitmapSource As Any Ptr, ByVal option_ As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 20. CreateBitmapFromSourceRect
    CreateBitmapFromSourceRect As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal piBitmapSource As Any Ptr, ByVal x As ULong, ByVal y As ULong, ByVal width As ULong, ByVal height As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 21. CreateBitmapFromMemory - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    CreateBitmapFromMemory As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal uiWidth As ULong, ByVal uiHeight As ULong, ByRef pixelFormat As GUID, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 22. CreateBitmapFromHBITMAP
    CreateBitmapFromHBITMAP As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal hBitmap As Any Ptr, ByVal hPalette As Any Ptr, ByVal options As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 23. CreateBitmapFromHICON
    CreateBitmapFromHICON As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal hIcon As Any Ptr, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 24. CreateComponentEnumerator
    CreateComponentEnumerator As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal componentTypes As ULong, ByVal options As ULong, ByVal ppIEnumUnknown As Any Ptr Ptr ) As HRESULT
        ' 25. CreateFastMetadataEncoderFromDecoder
    CreateFastMetadataEncoderFromDecoder As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pIDecoder As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr ) As HRESULT
        ' 26. CreateFastMetadataEncoderFromFrameDecode
    CreateFastMetadataEncoderFromFrameDecode As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pIFrameDecoder As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr ) As HRESULT
        ' 27. CreateQueryWriter
    CreateQueryWriter As Function(ByVal This As IWICImagingFactory2 Ptr,  ByRef guidMetadataFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr ) As HRESULT
        ' 28. CreateQueryWriterFromReader
    CreateQueryWriterFromReader As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pIQueryReader As Any Ptr, ByVal pguidVendor As GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr ) As HRESULT

        ' 4-28.  IWICImagingFactory
        ' 29. CreateImageEncoder
    CreateImageEncoder As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pD2DDevice As Any Ptr, ByVal ppWICImageEncoder As Any Ptr Ptr ) As HRESULT
        ' 30. CreateBitmapFromSourceRect (spezialisiert)
    CreateBitmapFromSourceRect1 As Function(ByVal This As IWICImagingFactory2 Ptr,  ByVal pIBitmapSource As Any Ptr, ByVal x As ULong, ByVal y As ULong, ByVal width As ULong, ByVal height As ULong, ByVal ppIBitmap As Any Ptr Ptr ) As HRESULT
        ' 31. CreateMetadataReader
    CreateMetadataReader As Function(ByVal This As IWICImagingFactory2 Ptr,  ByRef guidMetadataFormat As GUID, ByVal pguidVendor As GUID Ptr, ByVal dwOptions As ULong, ByVal ppIReader As Any Ptr Ptr ) As HRESULT
End Type
#define IWICImagingFactory2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICImagingFactory2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICImagingFactory2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICImagingFactory2_CreateDecoderFromFilename(p, a, b, c, d, e) (p)->lpVtbl->CreateDecoderFromFilename(p, a, b, c, d, e)
#define IWICImagingFactory2_CreateDecoderFromStream(p, a, b, c, d) (p)->lpVtbl->CreateDecoderFromStream(p, a, b, c, d)
#define IWICImagingFactory2_CreateDecoderFromFileHandle(p, a, b, c, d) (p)->lpVtbl->CreateDecoderFromFileHandle(p, a, b, c, d)
#define IWICImagingFactory2_CreateComponentInfo(p, a, b) (p)->lpVtbl->CreateComponentInfo(p, a, b)
#define IWICImagingFactory2_CreateDecoder(p, a, b, c) (p)->lpVtbl->CreateDecoder(p, a, b, c)
#define IWICImagingFactory2_CreateEncoder(p, a, b, c) (p)->lpVtbl->CreateEncoder(p, a, b, c)
#define IWICImagingFactory2_CreatePalette(p, a) (p)->lpVtbl->CreatePalette(p, a)
#define IWICImagingFactory2_CreateFormatConverter(p, a) (p)->lpVtbl->CreateFormatConverter(p, a)
#define IWICImagingFactory2_CreateBitmapScaler(p, a) (p)->lpVtbl->CreateBitmapScaler(p, a)
#define IWICImagingFactory2_CreateBitmapClipper(p, a) (p)->lpVtbl->CreateBitmapClipper(p, a)
#define IWICImagingFactory2_CreateBitmapFlipRotator(p, a) (p)->lpVtbl->CreateBitmapFlipRotator(p, a)
#define IWICImagingFactory2_CreateStream(p, a) (p)->lpVtbl->CreateStream(p, a)
#define IWICImagingFactory2_CreateColorContext(p, a) (p)->lpVtbl->CreateColorContext(p, a)
#define IWICImagingFactory2_CreateColorTransformer(p, a) (p)->lpVtbl->CreateColorTransformer(p, a)
#define IWICImagingFactory2_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define IWICImagingFactory2_CreateBitmapFromSource(p, a, b, c) (p)->lpVtbl->CreateBitmapFromSource(p, a, b, c)
#define IWICImagingFactory2_CreateBitmapFromSourceRect(p, a, b, c, d, e, f) (p)->lpVtbl->CreateBitmapFromSourceRect(p, a, b, c, d, e, f)
#define IWICImagingFactory2_CreateBitmapFromMemory(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateBitmapFromMemory(p, a, b, c, d, e, f, g)
#define IWICImagingFactory2_CreateBitmapFromHBITMAP(p, a, b, c, d) (p)->lpVtbl->CreateBitmapFromHBITMAP(p, a, b, c, d)
#define IWICImagingFactory2_CreateBitmapFromHICON(p, a, b) (p)->lpVtbl->CreateBitmapFromHICON(p, a, b)
#define IWICImagingFactory2_CreateComponentEnumerator(p, a, b, c) (p)->lpVtbl->CreateComponentEnumerator(p, a, b, c)
#define IWICImagingFactory2_CreateFastMetadataEncoderFromDecoder(p, a, b) (p)->lpVtbl->CreateFastMetadataEncoderFromDecoder(p, a, b)
#define IWICImagingFactory2_CreateFastMetadataEncoderFromFrameDecode(p, a, b) (p)->lpVtbl->CreateFastMetadataEncoderFromFrameDecode(p, a, b)
#define IWICImagingFactory2_CreateQueryWriter(p, a, b, c) (p)->lpVtbl->CreateQueryWriter(p, a, b, c)
#define IWICImagingFactory2_CreateQueryWriterFromReader(p, a, b, c) (p)->lpVtbl->CreateQueryWriterFromReader(p, a, b, c)
#define IWICImagingFactory2_CreateImageEncoder(p, a, b) (p)->lpVtbl->CreateImageEncoder(p, a, b)
#define IWICImagingFactory2_CreateBitmapFromSourceRect1(p, a, b, c, d, e, f) (p)->lpVtbl->CreateBitmapFromSourceRect1(p, a, b, c, d, e, f)
#define IWICImagingFactory2_CreateMetadataReader(p, a, b, c, d) (p)->lpVtbl->CreateMetadataReader(p, a, b, c, d)

' ============================================================================
' IWICEnumMetadataItem
' ============================================================================
Type IWICEnumMetadataItemVtbl As IWICEnumMetadataItemVtbl_
Type IWICEnumMetadataItem
    lpVtbl As IWICEnumMetadataItemVtbl Ptr
End Type
Type IWICEnumMetadataItemVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICEnumMetadataItem Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICEnumMetadataItem Ptr) As ULong
    Release As Function(ByVal This As IWICEnumMetadataItem Ptr) As ULong

        
    Next_ As Function(ByVal This As IWICEnumMetadataItem Ptr,  ByVal celt As ULong, ByRef rgeltSchema As VARIANT, ByRef rgeltId As VARIANT, ByRef rgeltValue As VARIANT, ByVal pceltFetched As ULong Ptr ) As HRESULT
        ' 5. Skip
    Skip As Function(ByVal This As IWICEnumMetadataItem Ptr,  ByVal celt As ULong ) As HRESULT
        ' 6. Reset
    Reset As Function(ByVal This As IWICEnumMetadataItem Ptr) As HRESULT
        ' 7. Clone
    Clone As Function(ByVal This As IWICEnumMetadataItem Ptr,  ByVal ppIEnumMetadataItem As Any Ptr Ptr ) As HRESULT
End Type
#define IWICEnumMetadataItem_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICEnumMetadataItem_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICEnumMetadataItem_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICEnumMetadataItem_Next_(p, a, b, c, d, e) (p)->lpVtbl->Next_(p, a, b, c, d, e)
#define IWICEnumMetadataItem_Skip(p, a) (p)->lpVtbl->Skip(p, a)
#define IWICEnumMetadataItem_Reset(p, a) (p)->lpVtbl->Reset(p, a)
#define IWICEnumMetadataItem_Clone(p, a) (p)->lpVtbl->Clone(p, a)

' ============================================================================
' IWICDdsDecoder
' ============================================================================
Type IWICDdsDecoderVtbl As IWICDdsDecoderVtbl_
Type IWICDdsDecoder
    lpVtbl As IWICDdsDecoderVtbl Ptr
End Type
Type IWICDdsDecoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICDdsDecoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICDdsDecoder Ptr) As ULong
    Release As Function(ByVal This As IWICDdsDecoder Ptr) As ULong

    
    GetParameters As Function(ByVal This As IWICDdsDecoder Ptr,  ByRef pParameters As WICDdsParameters ) As HRESULT
        ' 5. GetFrame
    GetFrame As Function(ByVal This As IWICDdsDecoder Ptr,  ByVal arrayIndex As ULong, ByVal mipLevel As ULong, ByVal sliceIndex As ULong, ByVal ppIBitmapFrame As Any Ptr Ptr ) As HRESULT
End Type
#define IWICDdsDecoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICDdsDecoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICDdsDecoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICDdsDecoder_GetParameters(p, a) (p)->lpVtbl->GetParameters(p, a)
#define IWICDdsDecoder_GetFrame(p, a, b, c, d) (p)->lpVtbl->GetFrame(p, a, b, c, d)

' ============================================================================
' IWICDdsEncoder
' ============================================================================
Type IWICDdsEncoderVtbl As IWICDdsEncoderVtbl_
Type IWICDdsEncoder
    lpVtbl As IWICDdsEncoderVtbl Ptr
End Type
Type IWICDdsEncoderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICDdsEncoder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICDdsEncoder Ptr) As ULong
    Release As Function(ByVal This As IWICDdsEncoder Ptr) As ULong

    
    SetParameters As Function(ByVal This As IWICDdsEncoder Ptr,  ByRef pParameters As WICDdsParameters ) As HRESULT
        ' 5. GetParameters - ACHTUNG: pParameters bleibt ByRef (Struktur)!
    GetParameters As Function(ByVal This As IWICDdsEncoder Ptr,  ByRef pParameters As WICDdsParameters ) As HRESULT
        ' 6. CreateNewFrame
    CreateNewFrame As Function(ByVal This As IWICDdsEncoder Ptr,  ByVal ppIFrameEncode As Any Ptr Ptr, ByVal pArrayIndex As ULong Ptr, ByVal pMipLevel As ULong Ptr, ByVal pSliceIndex As ULong Ptr ) As HRESULT
End Type
#define IWICDdsEncoder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICDdsEncoder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICDdsEncoder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICDdsEncoder_SetParameters(p, a) (p)->lpVtbl->SetParameters(p, a)
#define IWICDdsEncoder_GetParameters(p, a) (p)->lpVtbl->GetParameters(p, a)
#define IWICDdsEncoder_CreateNewFrame(p, a, b, c, d) (p)->lpVtbl->CreateNewFrame(p, a, b, c, d)

' ============================================================================
' IWICDdsFrameDecode
' ============================================================================
Type IWICDdsFrameDecodeVtbl As IWICDdsFrameDecodeVtbl_
Type IWICDdsFrameDecode
    lpVtbl As IWICDdsFrameDecodeVtbl Ptr
End Type
Type IWICDdsFrameDecodeVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IWICDdsFrameDecode Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICDdsFrameDecode Ptr) As ULong
    Release As Function(ByVal This As IWICDdsFrameDecode Ptr) As ULong

    
    GetSizeInBlocks As Function(ByVal This As IWICDdsFrameDecode Ptr,  ByVal pWidthInBlocks As ULong Ptr, ByVal pHeightInBlocks As ULong Ptr ) As HRESULT
        ' 5. GetFormatInfo - ACHTUNG: pFormatInfo bleibt ByRef (Struktur)!
    GetFormatInfo As Function(ByVal This As IWICDdsFrameDecode Ptr,  ByRef pFormatInfo As WICDdsFormatInfo ) As HRESULT
        ' 6. CopyBlocks
    CopyBlocks As Function(ByVal This As IWICDdsFrameDecode Ptr,  ByVal prcBoundsInBlocks As WICRect Ptr, ByVal cbStride As ULong, ByVal cbBufferSize As ULong, ByVal pbBuffer As UByte Ptr ) As HRESULT
End Type
#define IWICDdsFrameDecode_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IWICDdsFrameDecode_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IWICDdsFrameDecode_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IWICDdsFrameDecode_GetSizeInBlocks(p, a, b) (p)->lpVtbl->GetSizeInBlocks(p, a, b)
#define IWICDdsFrameDecode_GetFormatInfo(p, a) (p)->lpVtbl->GetFormatInfo(p, a)
#define IWICDdsFrameDecode_CopyBlocks(p, a, b, c, d) (p)->lpVtbl->CopyBlocks(p, a, b, c, d)

Extern "Windows"
Declare Function WICConvertBitmapSource(ByVal dstFormat As REFWICPixelFormatGUID, ByVal pISrc As IWICBitmapSource Ptr, ByVal ppIDst As IWICBitmapSource Ptr Ptr) As HRESULT
Declare Function WICCreateBitmapFromSection(ByVal width As UINT, ByVal height As UINT, ByVal format As REFWICPixelFormatGUID, ByVal section As HANDLE, ByVal stride As UINT, ByVal offset As UINT, ByVal bitmap As IWICBitmap Ptr Ptr) As HRESULT
Declare Function WICCreateBitmapFromSectionEx(ByVal width As UINT, ByVal height As UINT, ByVal format As REFWICPixelFormatGUID, ByVal section As HANDLE, ByVal stride As UINT, ByVal offset As UINT, ByVal access As WICSectionAccessLevel, ByVal bitmap As IWICBitmap Ptr Ptr) As HRESULT
Declare Function WICMapGuidToShortName(ByVal id As REFGUID, ByVal cchName As UINT, ByVal wzName As WCHAR Ptr, ByVal pcchActual As UINT Ptr) As HRESULT
Declare Function WICMapShortNameToGuid(ByVal wzName As PCWSTR, ByVal pguid As GUID Ptr) As HRESULT
Declare Function WICMapSchemaToName(ByVal guidSchema As REFGUID, ByVal wzName As LPWSTR, ByVal cchName As UINT, ByVal wzValue As WCHAR Ptr, ByVal pcchActual As UINT Ptr) As HRESULT
End Extern
