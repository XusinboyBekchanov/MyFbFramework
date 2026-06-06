' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

#define CODEC_FORCE_DWORD &h7FFFFFFF

' ============================================================
' Windows Imaging Component (WIC)
' ============================================================

' ------------------------------------------------------------
' Enums
' ------------------------------------------------------------

Enum WICDecodeOptions
    WICDecodeMetadataCacheOnDemand = &H00000000
    WICDecodeMetadataCacheOnLoad   = &H00000001
    WICMETADATACACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapCreateCacheOption
    WICBitmapNoCache        = &H00000000
    WICBitmapCacheOnDemand  = &H00000001
    WICBitmapCacheOnLoad    = &H00000002
    WICBITMAPCREATECACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapAlphaChannelOption
    WICBitmapUseAlpha               = &H00000000
    WICBitmapUsePremultipliedAlpha  = &H00000001
    WICBitmapIgnoreAlpha            = &H00000002
    WICBITMAPALPHACHANNELOPTIONS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapDecoderCapabilities
    WICBitmapDecoderCapabilitySameEncoder        = &H00000001
    WICBitmapDecoderCapabilityCanDecodeAllImages = &H00000002
    WICBitmapDecoderCapabilityCanDecodeSomeImages= &H00000004
    WICBitmapDecoderCapabilityCanEnumerateMetadata = &H00000008
    WICBitmapDecoderCapabilityCanDecodeThumbnail = &H00000010
End Enum

Enum WICBitmapDitherType
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

Enum WICBitmapEncoderCacheOption
    WICBitmapEncoderCacheInMemory = &H00000000
    WICBitmapEncoderCacheTempFile = &H00000001
    WICBitmapEncoderNoCache       = &H00000002
    WICBITMAPENCODERCACHEOPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapInterpolationMode
    WICBitmapInterpolationModeNearestNeighbor = &H00000000
    WICBitmapInterpolationModeLinear          = &H00000001
    WICBitmapInterpolationModeCubic           = &H00000002
    WICBitmapInterpolationModeFant            = &H00000003
    WICBITMAPINTERPOLATIONMODE_FORCE_DWORD    = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapLockFlags
    WICBitmapLockRead  = &H00000001
    WICBitmapLockWrite = &H00000002
    WICBITMAPLOCKFLAGS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICBitmapPaletteType
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

Enum WICBitmapTransformOptions
    WICBitmapTransformRotate0         = &H00000000
    WICBitmapTransformRotate90        = &H00000001
    WICBitmapTransformRotate180       = &H00000002
    WICBitmapTransformRotate270       = &H00000003
    WICBitmapTransformFlipHorizontal  = &H00000008
    WICBitmapTransformFlipVertical    = &H00000010
    WICBITMAPTRANSFORMOPTIONS_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICColorContextType
    WICColorContextUninitialized  = &H00000000
    WICColorContextProfile        = &H00000001
    WICColorContextExifColorSpace = &H00000002
End Enum

Enum WICComponentType
    WICDecoder               = &H00000001
    WICEncoder               = &H00000002
    WICPixelFormatConverter  = &H00000004
    WICMetadataReader        = &H00000008
    WICMetadataWriter        = &H00000010
    WICPixelFormat           = &H00000020
    WICCOMPONENTTYPE_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICComponentSigning
    WICComponentSigned   = &H00000001
    WICComponentUnsigned = &H00000002
    WICComponentSafe     = &H00000004
    WICComponentDisabled = &H80000000
End Enum

Enum WICComponentEnumerateOptions
    WICComponentEnumerateDefault      = &H00000000
    WICComponentEnumerateRefresh      = &H00000001
    WICComponentEnumerateBuiltInOnly  = &H20000000
    WICComponentEnumerateUnsigned     = &H40000000
    WICComponentEnumerateDisabled     = &H80000000
End Enum

Enum WICJpegYCrCbSubsamplingOption
    WICJpegYCrCbSubsamplingDefault = &H00000000
    WICJpegYCrCbSubsampling420     = &H00000001
    WICJpegYCrCbSubsampling422     = &H00000002
    WICJpegYCrCbSubsampling444     = &H00000003
    WICJpegYCrCbSubsampling440     = &H00000004
End Enum

Enum WICPixelFormatNumericRepresentation
    WICPixelFormatNumericRepresentationUnspecified = &H00000000
    WICPixelFormatNumericRepresentationIndexed     = &H00000001
    WICPixelFormatNumericRepresentationUnsignedInteger = &H00000002
    WICPixelFormatNumericRepresentationSignedInteger   = &H00000003
    WICPixelFormatNumericRepresentationFixed        = &H00000004
    WICPixelFormatNumericRepresentationFloat        = &H00000005
    WICPIXELFORMATNUMERICREPRESENTATION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICTiffCompressionOption
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

Enum WICPngFilterOption
    WICPngFilterUnspecified = 0
    WICPngFilterNone        = 1
    WICPngFilterSub         = 2
    WICPngFilterUp          = 3
    WICPngFilterAverage     = 4
    WICPngFilterPaeth       = 5
    WICPngFilterAdaptive    = 6
    WICPNGFILTEROPTION_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICSectionAccessLevel
    WICSectionAccessLevelRead      = &H00000001
    WICSectionAccessLevelReadWrite = &H00000003
    WICSectionAccessLevel_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICDdsDimension
    WICDdsTexture1D   = &H00000000
    WICDdsTexture2D   = &H00000001
    WICDdsTexture3D   = &H00000002
    WICDdsTextureCube = &H00000003
    WICDDSTEXTURE_FORCE_DWORD = CODEC_FORCE_DWORD
End Enum

Enum WICDdsAlphaMode
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
' 1. Die Wurzel (Muss von Object erben für ABSTRACT support)
Type IUnknownWIC Extends Object
    Declare Abstract Function QueryInterface stdcall (ByVal riid As Any Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    Declare Abstract Function AddRef stdcall () As ULong
    Declare Abstract Function Release stdcall () As ULong
End Type

' 2. Sequentieller Zugriff (Slots 4-5)
Type ISequentialStreamWIC Extends IUnknownWIC
    Declare Abstract Function Read stdcall (ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbRead As ULong Ptr) As HRESULT
    Declare Abstract Function Write stdcall (ByVal pv As Any Ptr, ByVal cb As ULong, ByVal pcbWritten As ULong Ptr) As HRESULT
End Type

' 3. Voller Stream Zugriff (Slots 6-14)
Type IStreamWIC Extends ISequentialStreamWIC
    Declare Abstract Function Seek stdcall (ByVal dlibMove As LongInt, ByVal dwOrigin As ULong, ByVal plibNewPosition As LongInt Ptr) As HRESULT
    Declare Abstract Function SetSize stdcall (ByVal libNewSize As LongInt) As HRESULT
    Declare Abstract Function CopyTo stdcall (ByVal pstm As IStreamWIC Ptr, ByVal cb As LongInt, ByVal pcbRead As LongInt Ptr, ByVal pcbWritten As LongInt Ptr) As HRESULT
    Declare Abstract Function Commit stdcall (ByVal grfCommitFlags As ULong) As HRESULT
    Declare Abstract Function Revert stdcall () As HRESULT
    Declare Abstract Function LockRegion stdcall (ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    Declare Abstract Function UnlockRegion stdcall (ByVal libOffset As LongInt, ByVal cb As LongInt, ByVal dwLockType As ULong) As HRESULT
    Declare Abstract Function Stat stdcall (ByVal pstatstg As Any Ptr, ByVal grfStatFlag As ULong) As HRESULT
    Declare Abstract Function Clone stdcall (ByVal ppstm As IStreamWIC Ptr Ptr) As HRESULT
End Type


' ==============================
' IWICColorContext
' ==============================
Type IWICColorContext Extends IUnknownBase
    ' 1-3. QueryInterface, AddRef, Release (via IUnknownBase)

    ' 4. InitializeFromFilename
    Declare Abstract Function InitializeFromFilename stdcall (ByVal wzFilename As WString Ptr) As HRESULT

    ' 5. InitializeFromMemory
    Declare Abstract Function InitializeFromMemory stdcall (ByVal pbBuffer As UByte Ptr, ByVal cbBufferSize As ULong) As HRESULT

    ' 6. InitializeFromExifColorSpace
    Declare Abstract Function InitializeFromExifColorSpace stdcall (ByVal value As ULong) As HRESULT

    ' 7. GetType
    Declare Abstract Function GetType stdcall (ByVal pType As ULong Ptr) As HRESULT

    ' 8. GetProfileBytes
    Declare Abstract Function GetProfileBytes stdcall (ByVal cbBuffer As ULong, _
                                                       ByVal pbBuffer As UByte Ptr, _
                                                       ByVal pcbActual As ULong Ptr) As HRESULT

    ' 9. GetExifColorSpace
    Declare Abstract Function GetExifColorSpace stdcall (ByVal pValue As ULong Ptr) As HRESULT
End Type


' ==============================
' IWICBitmapSource
' ==============================
Type IWICBitmapSource Extends IUnknownBase
    ' 4. GetSize - OUT-Parameter als Pointer
    Declare Abstract Function GetSize stdcall ( _
        ByVal puiWidth As ULong Ptr, _
        ByVal puiHeight As ULong Ptr _
    ) As HRESULT

    ' 5. GetPixelFormat - OUT-Parameter als Pointer
    Declare Abstract Function GetPixelFormat stdcall ( _
        ByVal pPixelFormat As GUID Ptr _
    ) As HRESULT

    ' 6. GetResolution - OUT-Parameter als Pointer
    Declare Abstract Function GetResolution stdcall ( _
        ByVal pDpiX As Double Ptr, _
        ByVal pDpiY As Double Ptr _
    ) As HRESULT

    ' 7. CopyPalette
    Declare Abstract Function CopyPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 8. CopyPixels
    Declare Abstract Function CopyPixels stdcall ( _
        ByVal prc As WICRect Ptr, _
        ByVal cbStride As ULong, _
        ByVal cbBufferSize As ULong, _
        ByVal pbBuffer As UByte Ptr _
    ) As HRESULT
End Type

' ==============================
' IWICBitmapLock
' ==============================
Type IWICBitmapLock Extends IUnknownBase
    ' 4. GetSize
    Declare Abstract Function GetSize stdcall (ByVal pWidth As ULong Ptr, _
                                               ByVal pHeight As ULong Ptr) As HRESULT

    ' 5. GetStride
    Declare Abstract Function GetStride stdcall (ByVal pcbStride As ULong Ptr) As HRESULT

    ' 6. GetDataPointer
    Declare Abstract Function GetDataPointer stdcall (ByVal pcbBufferSize As ULong Ptr, _
                                                      ByVal ppbData As UByte Ptr Ptr) As HRESULT

    ' 7. GetPixelFormat
    Declare Abstract Function GetPixelFormat stdcall (ByVal pPixelFormat As GUID Ptr) As HRESULT
End Type

' ==============================
' IWICBitmapFlipRotator
' ==============================
Type IWICBitmapFlipRotator Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource

    ' 9. Initialize
    Declare Abstract Function Initialize stdcall ( _
        ByVal pISource As IWICBitmapSource Ptr, _
        ByVal options As WICBitmapTransformOptions _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmap
' ============================================================================
Type IWICBitmap Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource (GetSize, GetPixelFormat, GetResolution, etc.)

    ' 9. Lock
    Declare Abstract Function Lock stdcall ( _
        ByVal prcLock As Any Ptr, _
        ByVal flags As ULong, _
        ByVal ppILock As Any Ptr Ptr _
    ) As HRESULT

    ' 10. SetPalette
    Declare Abstract Function SetPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 11. SetResolution
    Declare Abstract Function SetResolution stdcall ( _
        ByVal dpiX As Double, _
        ByVal dpiY As Double _
    ) As HRESULT
End Type

' ============================================================================
' IWICPalette
' ============================================================================
Type IWICPalette Extends IUnknownBase
    ' 1-3. IUnknown (QueryInterface, AddRef, Release)

    ' 4. InitializePredefined
    Declare Abstract Function InitializePredefined stdcall ( _
        ByVal ePaletteType As ULong, _
        ByVal fAddTransparentColor As Long _
    ) As HRESULT

    ' 5. InitializeCustom
    Declare Abstract Function InitializeCustom stdcall ( _
        ByVal pColors As ULong Ptr, _
        ByVal cCount As ULong _
    ) As HRESULT

    ' 6. InitializeFromBitmap
    Declare Abstract Function InitializeFromBitmap stdcall ( _
        ByVal pISurface As IWICBitmapSource Ptr, _
        ByVal cCount As ULong, _
        ByVal fAddTransparentColor As Long _
    ) As HRESULT

    ' 7. InitializeFromPalette
    Declare Abstract Function InitializeFromPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 8. GetType
    Declare Abstract Function GetType stdcall ( _
        ByVal pePaletteType As ULong Ptr _
    ) As HRESULT

    ' 9. GetColorCount
    Declare Abstract Function GetColorCount stdcall ( _
        ByVal pcCount As ULong Ptr _
    ) As HRESULT

    ' 10. GetColors
    Declare Abstract Function GetColors stdcall ( _
        ByVal cCount As ULong, _
        ByVal pColors As ULong Ptr, _
        ByVal pcActualCount As ULong Ptr _
    ) As HRESULT

    ' 11. IsBlackWhite
    Declare Abstract Function IsBlackWhite stdcall ( _
        ByVal pfIsBlackWhite As Long Ptr _
    ) As HRESULT

    ' 12. IsGrayscale
    Declare Abstract Function IsGrayscale stdcall ( _
        ByVal pfIsGrayscale As Long Ptr _
    ) As HRESULT

    ' 13. HasAlpha
    Declare Abstract Function HasAlpha stdcall ( _
        ByVal pfHasAlpha As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICComponentInfo
' ============================================================================
Type IWICComponentInfo Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)
    
    ' 4. GetComponentType
    Declare Abstract Function GetComponentType stdcall ( _
        ByVal pType As ULong Ptr _
    ) As HRESULT

    ' 5. GetCLSID
    Declare Abstract Function GetCLSID stdcall ( _
        ByVal pclsid As GUID Ptr _
    ) As HRESULT

    ' 6. GetSigningStatus
    Declare Abstract Function GetSigningStatus stdcall ( _
        ByVal pStatus As ULong Ptr _
    ) As HRESULT

    ' 7. GetAuthor
    Declare Abstract Function GetAuthor stdcall ( _
        ByVal cchAuthor As ULong, _
        ByVal wzAuthor As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 8. GetVendorGUID
    Declare Abstract Function GetVendorGUID stdcall ( _
        ByVal pguidVendor As GUID Ptr _
    ) As HRESULT

    ' 9. GetVersion
    Declare Abstract Function GetVersion stdcall ( _
        ByVal cchVersion As ULong, _
        ByVal wzVersion As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 10. GetSpecVersion
    Declare Abstract Function GetSpecVersion stdcall ( _
        ByVal cchSpecVersion As ULong, _
        ByVal wzSpecVersion As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 11. GetFriendlyName
    Declare Abstract Function GetFriendlyName stdcall ( _
        ByVal cchFriendlyName As ULong, _
        ByVal wzFriendlyName As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICMetadataQueryReader
' ============================================================================
Type IWICMetadataQueryReader Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)
    
    ' 4. GetContainerFormat
    Declare Abstract Function GetContainerFormat stdcall ( _
        ByVal pguidContainerFormat As GUID Ptr _
    ) As HRESULT

    ' 5. GetLocation
    Declare Abstract Function GetLocation stdcall ( _
        ByVal cchMaxLength As ULong, _
        ByVal wzNamespace As WString Ptr, _
        ByVal pcchActualLength As ULong Ptr _
    ) As HRESULT

    ' 6. GetMetadataByName
    Declare Abstract Function GetMetadataByName stdcall ( _
        ByVal wzName As WString Ptr, _
        ByVal pvarValue As Any Ptr _
    ) As HRESULT

    ' 7. GetEnumerator
    Declare Abstract Function GetEnumerator stdcall ( _
        ByVal ppIEnumString As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICMetadataQueryWriter
' ============================================================================
Type IWICMetadataQueryWriter Extends IWICMetadataQueryReader
    ' 1-3. IUnknown
    ' 4-7. IWICMetadataQueryReader
    
    ' 8. SetMetadataByName
    Declare Abstract Function SetMetadataByName stdcall ( _
        ByVal wzName As WString Ptr, _
        ByVal pvarValue As Any Ptr _
    ) As HRESULT

    ' 9. RemoveMetadataByName
    Declare Abstract Function RemoveMetadataByName stdcall ( _
        ByVal wzName As WString Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapFrameDecode
' ============================================================================
Type IWICBitmapFrameDecode Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource

    ' 9. GetMetadataQueryReader
    Declare Abstract Function GetMetadataQueryReader stdcall ( _
        ByVal ppIMetadataQueryReader As Any Ptr Ptr _
    ) As HRESULT

    ' 10. GetColorContexts
    Declare Abstract Function GetColorContexts stdcall ( _
        ByVal cCount As ULong, _
        ByVal ppIColorContexts As Any Ptr Ptr, _
        ByVal pcActualCount As ULong Ptr _
    ) As HRESULT

    ' 11. GetThumbnail
    Declare Abstract Function GetThumbnail stdcall ( _
        ByVal ppIThumbnail As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICPixelFormatInfo
' ============================================================================
Type IWICPixelFormatInfo Extends IWICComponentInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo

    ' 12. GetFormatGUID
    Declare Abstract Function GetFormatGUID stdcall ( _
        ByVal pFormat As GUID Ptr _
    ) As HRESULT

    ' 13. GetColorContext
    Declare Abstract Function GetColorContext stdcall ( _
        ByVal ppIColorContext As Any Ptr Ptr _
    ) As HRESULT

    ' 14. GetBitsPerPixel
    Declare Abstract Function GetBitsPerPixel stdcall ( _
        ByVal puiBitsPerPixel As ULong Ptr _
    ) As HRESULT

    ' 15. GetChannelCount
    Declare Abstract Function GetChannelCount stdcall ( _
        ByVal puiChannelCount As ULong Ptr _
    ) As HRESULT

    ' 16. GetChannelMask
    Declare Abstract Function GetChannelMask stdcall ( _
        ByVal uiChannelIndex As ULong, _
        ByVal cbMaskBuffer As ULong, _
        ByVal pbMaskBuffer As UByte Ptr, _
        ByVal pcbActual As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICPixelFormatInfo2
' ============================================================================
Type IWICPixelFormatInfo2 Extends IWICPixelFormatInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo
    ' 12-16. IWICPixelFormatInfo

    ' 17. SupportsTransparency
    Declare Abstract Function SupportsTransparency stdcall ( _
        ByVal pfSupportsTransparency As Long Ptr _
    ) As HRESULT

    ' 18. GetNumericRepresentation
    Declare Abstract Function GetNumericRepresentation stdcall ( _
        ByVal pNumericRepresentation As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapCodecInfo
' ============================================================================
Type IWICBitmapCodecInfo Extends IWICComponentInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo

    ' 12. GetContainerFormat
    Declare Abstract Function GetContainerFormat stdcall ( _
        ByVal pguidContainerFormat As GUID Ptr _
    ) As HRESULT

    ' 13. GetPixelFormats
    Declare Abstract Function GetPixelFormats stdcall ( _
        ByVal cFormats As ULong, _
        ByVal pguidPixelFormats As GUID Ptr, _
        ByVal pcActual As ULong Ptr _
    ) As HRESULT

    ' 14. GetColorManagementVersion
    Declare Abstract Function GetColorManagementVersion stdcall ( _
        ByVal cchColorManagementVersion As ULong, _
        ByVal wzColorManagementVersion As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 15. GetDeviceManufacturer
    Declare Abstract Function GetDeviceManufacturer stdcall ( _
        ByVal cchDeviceManufacturer As ULong, _
        ByVal wzDeviceManufacturer As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 16. GetDeviceModels
    Declare Abstract Function GetDeviceModels stdcall ( _
        ByVal cchDeviceModels As ULong, _
        ByVal wzDeviceModels As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 17. GetMimeTypes
    Declare Abstract Function GetMimeTypes stdcall ( _
        ByVal cchMimeTypes As ULong, _
        ByVal wzMimeTypes As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 18. GetFileExtensions
    Declare Abstract Function GetFileExtensions stdcall ( _
        ByVal cchFileExtensions As ULong, _
        ByVal wzFileExtensions As WString Ptr, _
        ByVal pcchActual As ULong Ptr _
    ) As HRESULT

    ' 19. DoesSupportAnimation
    Declare Abstract Function DoesSupportAnimation stdcall ( _
        ByVal pfSupportAnimation As Long Ptr _
    ) As HRESULT

    ' 20. DoesSupportChromakey
    Declare Abstract Function DoesSupportChromakey stdcall ( _
        ByVal pfSupportChromakey As Long Ptr _
    ) As HRESULT

    ' 21. DoesSupportLossless
    Declare Abstract Function DoesSupportLossless stdcall ( _
        ByVal pfSupportLossless As Long Ptr _
    ) As HRESULT

    ' 22. DoesSupportMultiframe
    Declare Abstract Function DoesSupportMultiframe stdcall ( _
        ByVal pfSupportMultiframe As Long Ptr _
    ) As HRESULT

    ' 23. MatchesMimeType
    Declare Abstract Function MatchesMimeType stdcall ( _
        ByVal wzMimeType As WString Ptr, _
        ByVal pfMatches As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapDecoderInfo
' ============================================================================
Type IWICBitmapDecoderInfo Extends IWICBitmapCodecInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo
    ' 12-23. IWICBitmapCodecInfo

    ' 24. GetPatterns
    Declare Abstract Function GetPatterns stdcall ( _
        ByVal cbSizeAutoRuntime As ULong, _
        ByVal pPatterns As Any Ptr, _
        ByVal pcPatterns As ULong Ptr, _
        ByVal pcbPatternsActual As ULong Ptr _
    ) As HRESULT

    ' 25. MatchesPattern
    Declare Abstract Function MatchesPattern stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal pfMatches As Long Ptr _
    ) As HRESULT

    ' 26. CreateInstance
    Declare Abstract Function CreateInstance stdcall ( _
        ByVal ppIBitmapDecoder As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapDecoder
' ============================================================================
Type IWICBitmapDecoder Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. QueryCapability
    Declare Abstract Function QueryCapability stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal pdwCapability As ULong Ptr _
    ) As HRESULT

    ' 5. Initialize
    Declare Abstract Function Initialize stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal cacheOptions As ULong _
    ) As HRESULT

    ' 6. GetContainerFormat
    Declare Abstract Function GetContainerFormat stdcall ( _
        ByVal pguidContainerFormat As GUID Ptr _
    ) As HRESULT

    ' 7. GetDecoderInfo
    Declare Abstract Function GetDecoderInfo stdcall ( _
        ByVal ppIDecoderInfo As Any Ptr Ptr _
    ) As HRESULT

    ' 8. CopyPalette
    Declare Abstract Function CopyPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 9. GetMetadataQueryReader
    Declare Abstract Function GetMetadataQueryReader stdcall ( _
        ByVal ppIMetadataQueryReader As Any Ptr Ptr _
    ) As HRESULT

    ' 10. GetPreview
    Declare Abstract Function GetPreview stdcall ( _
        ByVal ppIBitmapSource As Any Ptr Ptr _
    ) As HRESULT

    ' 11. GetColorContexts
    Declare Abstract Function GetColorContexts stdcall ( _
        ByVal cCount As ULong, _
        ByVal ppIColorContexts As Any Ptr Ptr, _
        ByVal pcActualCount As ULong Ptr _
    ) As HRESULT

    ' 12. GetThumbnail
    Declare Abstract Function GetThumbnail stdcall ( _
        ByVal ppIThumbnail As Any Ptr Ptr _
    ) As HRESULT

    ' 13. GetFrameCount
    Declare Abstract Function GetFrameCount stdcall ( _
        ByVal pCount As ULong Ptr _
    ) As HRESULT

    ' 14. GetFrame
    Declare Abstract Function GetFrame stdcall ( _
        ByVal index As ULong, _
        ByVal ppIBitmapFrame As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapFrameEncode
' ============================================================================
Type IWICBitmapFrameEncode Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. Initialize
    Declare Abstract Function Initialize stdcall ( _
        ByVal pIEncoderOptions As Any Ptr _
    ) As HRESULT

    ' 5. SetSize
    Declare Abstract Function SetSize stdcall ( _
        ByVal uiWidth As ULong, _
        ByVal uiHeight As ULong _
    ) As HRESULT

    ' 6. SetResolution
    Declare Abstract Function SetResolution stdcall ( _
        ByVal dpiX As Double, _
        ByVal dpiY As Double _
    ) As HRESULT

    ' 7. SetPixelFormat - ACHTUNG: Hier ist ByRef korrekt (REFGUID)!
    Declare Abstract Function SetPixelFormat stdcall ( _
        ByRef pPixelFormat As GUID _
    ) As HRESULT

    ' 8. SetColorContexts
    Declare Abstract Function SetColorContexts stdcall ( _
        ByVal cCount As ULong, _
        ByVal ppIColorContexts As Any Ptr Ptr _
    ) As HRESULT

    ' 9. SetPalette
    Declare Abstract Function SetPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 10. SetThumbnail
    Declare Abstract Function SetThumbnail stdcall ( _
        ByVal pIThumbnail As Any Ptr _
    ) As HRESULT

    ' 11. WritePixels
    Declare Abstract Function WritePixels stdcall ( _
        ByVal lineCount As ULong, _
        ByVal cbStride As ULong, _
        ByVal cbBufferSize As ULong, _
        ByVal pbPixels As UByte Ptr _
    ) As HRESULT

    ' 12. WriteSource
    Declare Abstract Function WriteSource stdcall ( _
        ByVal pIWICBitmapSource As Any Ptr, _
        ByVal prc As Any Ptr _
    ) As HRESULT

    ' 13. Commit
    Declare Abstract Function Commit stdcall () As HRESULT

    ' 14. GetMetadataQueryWriter
    Declare Abstract Function GetMetadataQueryWriter stdcall ( _
        ByVal ppIMetadataQueryWriter As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapEncoderInfo
' ============================================================================
Type IWICBitmapEncoderInfo Extends IWICBitmapCodecInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo
    ' 12-23. IWICBitmapCodecInfo

    ' 24. CreateInstance
    Declare Abstract Function CreateInstance stdcall ( _
        ByVal ppIBitmapEncoder As Any Ptr Ptr _
    ) As HRESULT

    ' 25. DoesSupportPreview
    Declare Abstract Function DoesSupportPreview stdcall ( _
        ByVal pfSupportPreview As Long Ptr _
    ) As HRESULT

    ' 26. DoesSupportThumbnail
    Declare Abstract Function DoesSupportThumbnail stdcall ( _
        ByVal pfSupportThumbnail As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapEncoder
' ============================================================================
Type IWICBitmapEncoder Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. Initialize
    Declare Abstract Function Initialize stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal cacheOptions As ULong _
    ) As HRESULT

    ' 5. GetContainerFormat
    Declare Abstract Function GetContainerFormat stdcall ( _
        ByVal pguidContainerFormat As GUID Ptr _
    ) As HRESULT

    ' 6. GetEncoderInfo
    Declare Abstract Function GetEncoderInfo stdcall ( _
        ByVal ppIEncoderInfo As Any Ptr Ptr _
    ) As HRESULT

    ' 7. SetColorContexts
    Declare Abstract Function SetColorContexts stdcall ( _
        ByVal cCount As ULong, _
        ByVal ppIColorContexts As Any Ptr Ptr _
    ) As HRESULT

    ' 8. SetPalette
    Declare Abstract Function SetPalette stdcall ( _
        ByVal pIPalette As Any Ptr _
    ) As HRESULT

    ' 9. SetThumbnail
    Declare Abstract Function SetThumbnail stdcall ( _
        ByVal pIThumbnail As Any Ptr _
    ) As HRESULT

    ' 10. SetPreview
    Declare Abstract Function SetPreview stdcall ( _
        ByVal pIPreview As Any Ptr _
    ) As HRESULT

    ' 11. CreateNewFrame
    Declare Abstract Function CreateNewFrame stdcall ( _
        ByVal ppIFrameEncode As Any Ptr Ptr, _
        ByVal ppIEncoderOptions As Any Ptr Ptr _
    ) As HRESULT

    ' 12. Commit
    Declare Abstract Function Commit stdcall () As HRESULT

    ' 13. GetMetadataQueryWriter
    Declare Abstract Function GetMetadataQueryWriter stdcall ( _
        ByVal ppIMetadataQueryWriter As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICFormatConverter
' ============================================================================
Type IWICFormatConverter Extends IWICBitmapSource
    ' 9. Initialize - ACHTUNG: dstFormat bleibt ByRef (REFGUID)!
    Declare Abstract Function Initialize stdcall ( _
        ByVal pISource As IWICBitmapSource Ptr, _
        ByRef dstFormat As GUID, _
        ByVal dither As WICBitmapDitherType, _
        ByVal pIPalette As Any Ptr, _
        ByVal alphaThresholdPercent As Double, _
        ByVal paletteTranslate As WICBitmapPaletteType _
    ) As HRESULT

    ' 10. CanConvert - ACHTUNG: srcFormat und dstFormat bleiben ByRef (REFGUID)!
    Declare Abstract Function CanConvert stdcall ( _
        ByRef srcFormat As GUID, _
        ByRef dstFormat As GUID, _
        ByVal pfCanConvert As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICFormatConverterInfo
' ============================================================================
Type IWICFormatConverterInfo Extends IWICComponentInfo
    ' 1-3.   IUnknown
    ' 4-11.  IWICComponentInfo

    ' 12. GetPixelFormats
    Declare Abstract Function GetPixelFormats stdcall ( _
        ByVal cFormats As ULong, _
        ByVal pPixelFormatGUIDs As GUID Ptr, _
        ByVal pcActual As ULong Ptr _
    ) As HRESULT

    ' 13. CreateInstance
    Declare Abstract Function CreateInstance stdcall ( _
        ByVal ppIConverter As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICStream
' ============================================================================
Type IWICStream Extends IStreamWIC
    ' 1-3.   IUnknown
    ' 4-5.   ISequentialStream
    ' 6-14.  IStream

    ' 15. InitializeFromIStream
    Declare Abstract Function InitializeFromIStream stdcall ( _
        ByVal pIStream As Any Ptr _
    ) As HRESULT

    ' 16. InitializeFromFilename
    Declare Abstract Function InitializeFromFilename stdcall ( _
        ByVal wzFileName As WString Ptr, _
        ByVal dwDesiredAccess As ULong _
    ) As HRESULT

    ' 17. InitializeFromMemory
    Declare Abstract Function InitializeFromMemory stdcall ( _
        ByVal pbBuffer As UByte Ptr, _
        ByVal cbBufferSize As ULong _
    ) As HRESULT

    ' 18. InitializeFromIStreamRegion
    Declare Abstract Function InitializeFromIStreamRegion stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal ulOffset As ULARGE_INTEGER, _
        ByVal ulMaxSize As ULARGE_INTEGER _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapScaler
' ============================================================================
Type IWICBitmapScaler Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource

    ' 9. Initialize
    Declare Abstract Function Initialize Stdcall ( _
        ByVal pISource As IWICBitmapSource Ptr, _
        ByVal uiWidth As ULong, _
        ByVal uiHeight As ULong, _
        ByVal mode As WICBitmapInterpolationMode _
    ) As HRESULT
End Type

' ============================================================================
' IWICBitmapClipper
' ============================================================================
Type IWICBitmapClipper Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource

    ' 9. Initialize
    Declare Abstract Function Initialize Stdcall ( _
        ByVal pISource As IWICBitmapSource Ptr, _
        ByVal pRect As WICRect Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICColorTransform
' ============================================================================
Type IWICColorTransform Extends IWICBitmapSource
    ' 1-3. IUnknown
    ' 4-8. IWICBitmapSource

    ' 9. Initialize - ACHTUNG: pixelFormatDest bleibt ByRef (REFGUID)!
    Declare Abstract Function Initialize Stdcall ( _
        ByVal pIBitmapSource As IWICBitmapSource Ptr, _
        ByVal pIContextSource As Any Ptr, _
        ByVal pIContextDest As Any Ptr, _
        ByRef pixelFormatDest As GUID _
    ) As HRESULT
End Type

' ============================================================================
' IWICFastMetadataEncoder
' ============================================================================
Type IWICFastMetadataEncoder Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. Commit
    Declare Abstract Function Commit Stdcall () As HRESULT

    ' 5. GetMetadataQueryWriter
    Declare Abstract Function GetMetadataQueryWriter Stdcall ( _
        ByVal ppIMetadataQueryWriter As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICImageEncoder
' ============================================================================
Type IWICImageEncoder Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. WriteFrame
    Declare Abstract Function WriteFrame stdcall ( _
        ByVal pImage As Any Ptr, _
        ByVal pFrameEncode As Any Ptr, _
        ByVal pImageParameters As Any Ptr _
    ) As HRESULT

    ' 5. WriteFrameThumbnail
    Declare Abstract Function WriteFrameThumbnail stdcall ( _
        ByVal pImage As Any Ptr, _
        ByVal pFrameEncode As Any Ptr, _
        ByVal pImageParameters As Any Ptr _
    ) As HRESULT

    ' 6. WriteThumbnail
    Declare Abstract Function WriteThumbnail stdcall ( _
        ByVal pImage As Any Ptr, _
        ByVal pEncoder As Any Ptr, _
        ByVal pImageParameters As Any Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICImagingFactory
' ============================================================================
Type IWICImagingFactory Extends IUnknownBase
    ' 4. CreateDecoderFromFilename
    Declare Abstract Function CreateDecoderFromFilename stdcall ( _
        ByVal wzFilename As WString Ptr, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal dwDesiredAccess As ULong, _
        ByVal metadataOptions As ULong, _
        ByVal ppIDecoder As IWICBitmapDecoder Ptr Ptr _
    ) As HRESULT

    ' 5. CreateDecoderFromStream
    Declare Abstract Function CreateDecoderFromStream stdcall ( _
        ByVal pIStream As Any Ptr, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal metadataOptions As ULong, _
        ByVal ppIDecoder As Any Ptr Ptr _
    ) As HRESULT

    ' 6. CreateDecoderFromFileHandle
    Declare Abstract Function CreateDecoderFromFileHandle stdcall ( _
        ByVal hFile As Any Ptr, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal metadataOptions As ULong, _
        ByVal ppIDecoder As Any Ptr Ptr _
    ) As HRESULT

    ' 7. CreateComponentInfo
    Declare Abstract Function CreateComponentInfo stdcall ( _
        ByRef clsidComponent As GUID, _
        ByVal ppIInfo As Any Ptr Ptr _
    ) As HRESULT

    ' 8. CreateDecoder
    Declare Abstract Function CreateDecoder stdcall ( _
        ByRef guidContainerFormat As GUID, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal ppIDecoder As Any Ptr Ptr _
    ) As HRESULT

    ' 9. CreateEncoder
    Declare Abstract Function CreateEncoder stdcall ( _
        ByVal guidContainerFormat As GUID, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal ppIEncoder As IWICBitmapEncoder Ptr Ptr _
    ) As HRESULT

    ' 10. CreatePalette
    Declare Abstract Function CreatePalette stdcall ( _
        ByVal ppIPalette As Any Ptr Ptr _
    ) As HRESULT

    ' 11. CreateFormatConverter
    Declare Abstract Function CreateFormatConverter stdcall ( _
        ByVal ppIFormatConverter As Any Ptr Ptr _
    ) As HRESULT

    ' 12. CreateBitmapScaler
    Declare Abstract Function CreateBitmapScaler stdcall ( _
        ByVal ppIBitmapScaler As Any Ptr Ptr _
    ) As HRESULT

    ' 13. CreateBitmapClipper
    Declare Abstract Function CreateBitmapClipper stdcall ( _
        ByVal ppIBitmapClipper As Any Ptr Ptr _
    ) As HRESULT

    ' 14. CreateBitmapFlipRotator
    Declare Abstract Function CreateBitmapFlipRotator stdcall ( _
        ByVal ppIBitmapFlipRotator As Any Ptr Ptr _
    ) As HRESULT

    ' 15. CreateStream
    Declare Abstract Function CreateStream stdcall ( _
        ByVal ppIWICStream As Any Ptr Ptr _
    ) As HRESULT

    ' 16. CreateColorContext
    Declare Abstract Function CreateColorContext stdcall ( _
        ByVal ppIWICColorContext As Any Ptr Ptr _
    ) As HRESULT

    ' 17. CreateColorTransformer
    Declare Abstract Function CreateColorTransformer stdcall ( _
        ByVal ppIWICColorTransform As Any Ptr Ptr _
    ) As HRESULT

    ' 18. CreateBitmap - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    Declare Abstract Function CreateBitmap Stdcall ( _
        ByVal uiWidth As ULong, _
        ByVal uiHeight As ULong, _
        ByRef pixelFormat As GUID, _
        ByVal option_ As ULong, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 19. CreateBitmapFromSource
    Declare Abstract Function CreateBitmapFromSource stdcall ( _
        ByVal piBitmapSource As Any Ptr, _
        ByVal option_ As ULong, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 20. CreateBitmapFromSourceRect
    Declare Abstract Function CreateBitmapFromSourceRect stdcall ( _
        ByVal piBitmapSource As Any Ptr, _
        ByVal x As ULong, ByVal y As ULong, _
        ByVal width As ULong, ByVal height As ULong, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 21. CreateBitmapFromMemory - ACHTUNG: pixelFormat bleibt ByRef (REFGUID)!
    Declare Abstract Function CreateBitmapFromMemory stdcall ( _
        ByVal uiWidth As ULong, _
        ByVal uiHeight As ULong, _
        ByRef pixelFormat As GUID, _
        ByVal cbStride As ULong, _
        ByVal cbBufferSize As ULong, _
        ByVal pbBuffer As UByte Ptr, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 22. CreateBitmapFromHBITMAP
    Declare Abstract Function CreateBitmapFromHBITMAP stdcall ( _
        ByVal hBitmap As Any Ptr, _
        ByVal hPalette As Any Ptr, _
        ByVal options As ULong, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 23. CreateBitmapFromHICON
    Declare Abstract Function CreateBitmapFromHICON Stdcall ( _
        ByVal hIcon As Any Ptr, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 24. CreateComponentEnumerator
    Declare Abstract Function CreateComponentEnumerator Stdcall ( _
        ByVal componentTypes As ULong, _
        ByVal options As ULong, _
        ByVal ppIEnumUnknown As Any Ptr Ptr _
    ) As HRESULT

    ' 25. CreateFastMetadataEncoderFromDecoder
    Declare Abstract Function CreateFastMetadataEncoderFromDecoder Stdcall ( _
        ByVal pIDecoder As Any Ptr, _
        ByVal ppIFastEncoder As Any Ptr Ptr _
    ) As HRESULT

    ' 26. CreateFastMetadataEncoderFromFrameDecode
    Declare Abstract Function CreateFastMetadataEncoderFromFrameDecode Stdcall ( _
        ByVal pIFrameDecoder As Any Ptr, _
        ByVal ppIFastEncoder As Any Ptr Ptr _
    ) As HRESULT

    ' 27. CreateQueryWriter
    Declare Abstract Function CreateQueryWriter Stdcall ( _
        ByRef guidMetadataFormat As GUID, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal ppIQueryWriter As Any Ptr Ptr _
    ) As HRESULT

    ' 28. CreateQueryWriterFromReader
    Declare Abstract Function CreateQueryWriterFromReader stdcall ( _
        ByVal pIQueryReader As Any Ptr, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal ppIQueryWriter As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICImagingFactory2
' ============================================================================
Type IWICImagingFactory2 Extends IWICImagingFactory
    ' 1-3.   IUnknown
    ' 4-28.  IWICImagingFactory

    ' 29. CreateImageEncoder
    Declare Abstract Function CreateImageEncoder stdcall ( _
        ByVal pD2DDevice As Any Ptr, _
        ByVal ppWICImageEncoder As Any Ptr Ptr _
    ) As HRESULT

    ' 30. CreateBitmapFromSourceRect (spezialisiert)
    Declare Abstract Function CreateBitmapFromSourceRect Stdcall ( _
        ByVal pIBitmapSource As Any Ptr, _
        ByVal x As ULong, _
        ByVal y As ULong, _
        ByVal width As ULong, _
        ByVal height As ULong, _
        ByVal ppIBitmap As Any Ptr Ptr _
    ) As HRESULT

    ' 31. CreateMetadataReader
    Declare Abstract Function CreateMetadataReader Stdcall ( _
        ByRef guidMetadataFormat As GUID, _
        ByVal pguidVendor As GUID Ptr, _
        ByVal dwOptions As ULong, _
        ByVal ppIReader As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICEnumMetadataItem
' ============================================================================
Type IWICEnumMetadataItem Extends IUnknownBase
    ' 1-3. IUnknown
    
    ' 4. Next - ACHTUNG: Die VARIANT Parameter bleiben als Referenz!
    Declare Abstract Function Next_ Stdcall ( _
        ByVal celt As ULong, _
        ByRef rgeltSchema As VARIANT, _
        ByRef rgeltId As VARIANT, _
        ByRef rgeltValue As VARIANT, _
        ByVal pceltFetched As ULong Ptr _
    ) As HRESULT

    ' 5. Skip
    Declare Abstract Function Skip Stdcall ( _
        ByVal celt As ULong _
    ) As HRESULT

    ' 6. Reset
    Declare Abstract Function Reset Stdcall () As HRESULT

    ' 7. Clone
    Declare Abstract Function Clone Stdcall ( _
        ByVal ppIEnumMetadataItem As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICDdsDecoder
' ============================================================================
Type IWICDdsDecoder Extends IUnknownBase
    ' 1-3. IUnknown

    ' 4. GetParameters - ACHTUNG: pParameters bleibt ByRef (Struktur)!
    Declare Abstract Function GetParameters Stdcall ( _
        ByRef pParameters As WICDdsParameters _
    ) As HRESULT

    ' 5. GetFrame
    Declare Abstract Function GetFrame Stdcall ( _
        ByVal arrayIndex As ULong, _
        ByVal mipLevel As ULong, _
        ByVal sliceIndex As ULong, _
        ByVal ppIBitmapFrame As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICDdsEncoder
' ============================================================================
Type IWICDdsEncoder Extends IUnknownBase
    ' 1-3. IUnknown

    ' 4. SetParameters - ACHTUNG: pParameters bleibt ByRef (Struktur)!
    Declare Abstract Function SetParameters Stdcall ( _
        ByRef pParameters As WICDdsParameters _
    ) As HRESULT

    ' 5. GetParameters - ACHTUNG: pParameters bleibt ByRef (Struktur)!
    Declare Abstract Function GetParameters Stdcall ( _
        ByRef pParameters As WICDdsParameters _
    ) As HRESULT

    ' 6. CreateNewFrame
    Declare Abstract Function CreateNewFrame Stdcall ( _
        ByVal ppIFrameEncode As Any Ptr Ptr, _
        ByVal pArrayIndex As ULong Ptr, _
        ByVal pMipLevel As ULong Ptr, _
        ByVal pSliceIndex As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IWICDdsFrameDecode
' ============================================================================
Type IWICDdsFrameDecode Extends IUnknownBase
    ' 1-3. IUnknown

    ' 4. GetSizeInBlocks
    Declare Abstract Function GetSizeInBlocks Stdcall ( _
        ByVal pWidthInBlocks As ULong Ptr, _
        ByVal pHeightInBlocks As ULong Ptr _
    ) As HRESULT

    ' 5. GetFormatInfo - ACHTUNG: pFormatInfo bleibt ByRef (Struktur)!
    Declare Abstract Function GetFormatInfo Stdcall ( _
        ByRef pFormatInfo As WICDdsFormatInfo _
    ) As HRESULT

    ' 6. CopyBlocks
    Declare Abstract Function CopyBlocks Stdcall ( _
        ByVal prcBoundsInBlocks As WICRect Ptr, _
        ByVal cbStride As ULong, _
        ByVal cbBufferSize As ULong, _
        ByVal pbBuffer As UByte Ptr _
    ) As HRESULT
End Type

Extern "Windows"

Declare Function WICConvertBitmapSource(ByVal dstFormat As REFWICPixelFormatGUID, ByVal pISrc As IWICBitmapSource Ptr, ByVal ppIDst As IWICBitmapSource Ptr Ptr) As HRESULT
Declare Function WICCreateBitmapFromSection(ByVal width As UINT, ByVal height As UINT, ByVal format As REFWICPixelFormatGUID, ByVal section As HANDLE, ByVal stride As UINT, ByVal offset As UINT, ByVal bitmap As IWICBitmap Ptr Ptr) As HRESULT
Declare Function WICCreateBitmapFromSectionEx(ByVal width As UINT, ByVal height As UINT, ByVal format As REFWICPixelFormatGUID, ByVal section As HANDLE, ByVal stride As UINT, ByVal offset As UINT, ByVal access As WICSectionAccessLevel, ByVal bitmap As IWICBitmap Ptr Ptr) As HRESULT

Declare Function WICMapGuidToShortName(ByVal id As REFGUID, ByVal cchName As UINT, ByVal wzName As WCHAR Ptr, ByVal pcchActual As UINT Ptr) As HRESULT
Declare Function WICMapShortNameToGuid(ByVal wzName As PCWSTR, ByVal pguid As GUID Ptr) As HRESULT
Declare Function WICMapSchemaToName(ByVal guidSchema As REFGUID, ByVal wzName As LPWSTR, ByVal cchName As UINT, ByVal wzValue As WCHAR Ptr, ByVal pcchActual As UINT Ptr) As HRESULT

End Extern