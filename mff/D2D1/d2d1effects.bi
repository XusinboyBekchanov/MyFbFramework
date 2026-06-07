' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' ============================================================================
' Direct2D Effects API - FreeBASIC Translation
' ============================================================================

' ============================================================================
' Direct2D Effect CLSIDs
' ============================================================================

Dim Shared CLSID_D2D12DAffineTransform As GUID = Type(&h6aa97485, &h6354, &h4cfc, {&h90, &h8c, &he4, &ha7, &h4f, &h62, &hc9, &h6c})
Dim Shared CLSID_D2D13DPerspectiveTransform As GUID = Type(&hc2844d0b, &h3d86, &h46e7, {&h85, &hba, &h52, &h6c, &h92, &h40, &hf3, &hfb})
Dim Shared CLSID_D2D13DTransform As GUID = Type(&he8467b04, &hec61, &h4b8a, {&hb5, &hde, &hd4, &hd7, &h3d, &heb, &hea, &h5a})
Dim Shared CLSID_D2D1AlphaMask As GUID = Type(&hc80ecff0, &h3fd5, &h4f05, {&h83, &h28, &hc5, &hd1, &h72, &h4b, &h4f, &h0a})
Dim Shared CLSID_D2D1ArithmeticComposite As GUID = Type(&hfc151437, &h049a, &h4784, {&ha2, &h4a, &hf1, &hc4, &hda, &hf2, &h09, &h87})
Dim Shared CLSID_D2D1Atlas As GUID = Type(&h913e2be4, &hfdcf, &h4fe2, {&ha5, &hf0, &h24, &h54, &hf1, &h4f, &hf4, &h08})
Dim Shared CLSID_D2D1BitmapSource As GUID = Type(&h5fb6c24d, &hc6dd, &h4231, {&h94, &h04, &h50, &hf4, &hd5, &hc3, &h25, &h2d})
Dim Shared CLSID_D2D1Blend As GUID = Type(&h81c5b77b, &h13f8, &h4cdd, {&had, &h20, &hc8, &h90, &h54, &h7a, &hc6, &h5d})
Dim Shared CLSID_D2D1Border As GUID = Type(&h2a2d49c0, &h4acf, &h43c7, {&h8c, &h6a, &h7c, &h4a, &h27, &h87, &h4d, &h27})
Dim Shared CLSID_D2D1Brightness As GUID = Type(&h8cea8d1e, &h77b0, &h4986, {&hb3, &hb9, &h2f, &h0c, &h0e, &hae, &h78, &h87})
Dim Shared CLSID_D2D1ChromaKey As GUID = Type(&h74c01f5b, &h2a0d, &h408c, {&h88, &he2, &hc7, &ha3, &hc7, &h19, &h77, &h42})
Dim Shared CLSID_D2D1ColorManagement As GUID = Type(&h1a28524c, &hfdd6, &h4aa4, {&hae, &h8f, &h83, &h7e, &hb8, &h26, &h7b, &h37})
Dim Shared CLSID_D2D1ColorMatrix As GUID = Type(&h921f03d6, &h641c, &h47df, {&h85, &h2d, &hb4, &hbb, &h61, &h53, &hae, &h11})
Dim Shared CLSID_D2D1Composite As GUID = Type(&h48fc9f51, &hf6ac, &h48f1, {&h8b, &h58, &h3b, &h28, &hac, &h46, &hf7, &h6d})
Dim Shared CLSID_D2D1Contrast As GUID = Type(&hb648a78a, &h0ed5, &h4f80, {&ha9, &h4a, &h8e, &h82, &h5a, &hca, &h6b, &h77})
Dim Shared CLSID_D2D1ConvolveMatrix As GUID = Type(&h407f8c08, &h5533, &h4331, {&ha3, &h41, &h23, &hcc, &h38, &h77, &h84, &h3e})
Dim Shared CLSID_D2D1Crop As GUID = Type(&he23f7110, &h0e9a, &h4324, {&haf, &h47, &h6a, &h2c, &h0c, &h46, &hf3, &h5b})
Dim Shared CLSID_D2D1CrossFade As GUID = Type(&h12f575e8, &h4db1, &h485f, {&h9a, &h84, &h03, &ha0, &h7d, &hd3, &h82, &h9f})
Dim Shared CLSID_CustomPixelateEffect As GUID = Type(&h12345678, &h1234, &h1234, {&h12, &h34, &h56, &h78, &h9A, &hBC, &hDE, &hF0})
Dim Shared CLSID_D2D1DirectionalBlur As GUID = Type(&h174319a6, &h58e9, &h49b2, {&hbb, &h63, &hca, &hf2, &hc8, &h11, &ha3, &hdb})
Dim Shared CLSID_D2D1DiscreteTransfer As GUID = Type(&h90866fcd, &h488e, &h454b, {&haf, &h06, &he5, &h04, &h1b, &h66, &hc3, &h6c})
Dim Shared CLSID_D2D1DisplacementMap As GUID = Type(&hedc48364, &h0417, &h4111, {&h94, &h50, &h43, &h84, &h5f, &ha9, &hf8, &h90})
Dim Shared CLSID_D2D1DistantDiffuse As GUID = Type(&h3e7efd62, &ha32d, &h46d4, {&ha8, &h3c, &h52, &h78, &h88, &h9a, &hc9, &h54})
Dim Shared CLSID_D2D1DistantSpecular As GUID = Type(&h428c1ee5, &h77b8, &h4450, {&h8a, &hb5, &h72, &h21, &h9c, &h21, &hab, &hda})
Dim Shared CLSID_D2D1DpiCompensation As GUID = Type(&h6c26c5c7, &h34e0, &h46fc, {&h9c, &hfd, &he5, &h82, &h37, &h06, &he2, &h28})
Dim Shared CLSID_D2D1EdgeDetection As GUID = Type(&hEFF583CA, &hCB07, &h4AA9, {&hAC, &h5D, &h2C, &hC4, &h4C, &hF0, &h95, &hC6})
Dim Shared CLSID_D2D1Emboss As GUID = Type(&hb1c5eb2b, &h0348, &h43f0, {&h81, &h07, &h49, &h57, &hca, &hcb, &ha2, &hae})
Dim Shared CLSID_D2D1Exposure As GUID = Type(&hb56c8cfa, &hf634, &h41ee, {&hbe, &he0, &hff, &ha6, &h17, &h10, &h60, &h04})
Dim Shared CLSID_D2D1Flood As GUID = Type(&h61c23c20, &hae69, &h4d8e, {&h94, &hcf, &h50, &h07, &h8d, &hf6, &h38, &hf2})
Dim Shared CLSID_D2D1GammaTransfer As GUID = Type(&h409444c4, &hc419, &h41a0, {&hb0, &hc1, &h8c, &hd0, &hc0, &ha1, &h8e, &h42})
Dim Shared CLSID_D2D1GaussianBlur As GUID = Type(&h1feb6d69, &h2fe6, &h4ac9, {&h8c, &h58, &h1d, &h7f, &h93, &he7, &ha6, &ha5})
Dim Shared CLSID_D2D1Grayscale As GUID = Type(&h36DDE0EB, &h3725, &h42E0, {&h83, &h6D, &h52, &hFB, &h20, &hAE, &hE6, &h44})
Dim Shared CLSID_D2D1Scale As GUID = Type(&h9daf9369, &h3846, &h4d0e, {&ha4, &h4e, &h0c, &h60, &h79, &h34, &ha5, &hd7})
Dim Shared CLSID_D2D1HighlightsShadows As GUID = Type(&hcadc8384, &h323f, &h4c7e, {&ha3, &h61, &h2e, &h2b, &h24, &hdf, &h6e, &he4})
Dim Shared CLSID_D2D1Histogram As GUID = Type(&h881db7d0, &hf7ee, &h4d4d, {&ha6, &hd2, &h46, &h97, &hac, &hc6, &h6e, &he8})
Dim Shared CLSID_D2D1HueRotation As GUID = Type(&h0f4458ec, &h4b32, &h491b, {&h9e, &h85, &hbd, &h73, &hf4, &h4d, &h3e, &hb6})
Dim Shared CLSID_D2D1HueToRgb As GUID = Type(&h7b78a6bd, &h0141, &h4def, {&h8a, &h52, &h63, &h56, &hee, &h0c, &hbd, &hd5})
Dim Shared CLSID_D2D1Invert As GUID = Type(&he0c3784d, &hcb39, &h4e84, {&hb6, &hfd, &h6b, &h72, &hf0, &h81, &h02, &h63})
Dim Shared CLSID_D2D1LinearTransfer As GUID = Type(&had47c8fd, &h63ef, &h4acc, {&h9b, &h51, &h67, &h97, &h9c, &h03, &h6c, &h06})
Dim Shared CLSID_D2D1LookupTable3D As GUID = Type(&h349e0eda, &h0088, &h4a79, {&h9c, &ha3, &hc7, &he3, &h00, &h20, &h20, &h20})
Dim Shared CLSID_D2D1LuminanceToAlpha As GUID = Type(&h41251ab7, &h0beb, &h46f8, {&h9d, &ha7, &h59, &he9, &h3f, &hcc, &he5, &hde})
Dim Shared CLSID_D2D1Morphology As GUID = Type(&heae6c40d, &h626a, &h4c2d, {&hbf, &hcb, &h39, &h10, &h01, &hab, &he2, &h02})
Dim Shared CLSID_D2D1Opacity As GUID = Type(&h811d79a4, &hde28, &h4454, {&h80, &h94, &hc6, &h46, &h85, &hf8, &hbd, &h4c})
Dim Shared CLSID_D2D1OpacityMetadata As GUID = Type(&h6c53006a, &h4450, &h4199, {&haa, &h5b, &had, &h16, &h56, &hfe, &hce, &h5e})
Dim Shared CLSID_D2D1PointDiffuse As GUID = Type(&hb9e303c3, &hc08c, &h4f91, {&h8b, &h7b, &h38, &h65, &h6b, &hc4, &h8c, &h20})
Dim Shared CLSID_D2D1PointSpecular As GUID = Type(&h09c3ca26, &h3ae2, &h4f09, {&h9e, &hbc, &hed, &h38, &h65, &hd5, &h3f, &h22})
Dim Shared CLSID_D2D1Posterize As GUID = Type(&h2188945E, &h33A3, &h4366, {&hB7, &hBC, &h08, &h6B, &hD0, &h2D, &h08, &h84})
Dim Shared CLSID_D2D1Premultiply As GUID = Type(&h06eab419, &hdeed, &h4018, {&h80, &hd2, &h3e, &h1d, &h47, &h1a, &hde, &hb2})
Dim Shared CLSID_D2D1RgbToHue As GUID = Type(&h23f3e5ec, &h91e8, &h4d3d, {&had, &h0a, &haf, &had, &hc1, &h00, &h4a, &ha1})
Dim Shared CLSID_D2D1Saturation As GUID = Type(&h5cb2d9cf, &h327d, &h459f, {&ha0, &hce, &h40, &hc0, &hb2, &h08, &h6b, &hf7})
Dim Shared CLSID_D2D1Sepia As GUID = Type(&h3a1af410, &h5f1d, &h4dbe, {&h84, &hdf, &h91, &h5d, &ha7, &h9b, &h71, &h53})
Dim Shared CLSID_D2D1Shadow As GUID = Type(&hc67ea361, &h1863, &h4e69, {&h89, &hdb, &h69, &h5d, &h3e, &h9a, &h5b, &h6b})
Dim Shared CLSID_D2D1Sharpen As GUID = Type(&hC9B887CB, &h3CD1, &h4F74, {&h90, &hCB, &h09, &h84, &h80, &hE7, &h60, &h60})
Dim Shared CLSID_D2D1SpotDiffuse As GUID = Type(&h818a1105, &h7932, &h44f4, {&haa, &h86, &h08, &hae, &h7b, &h2f, &h2c, &h93})
Dim Shared CLSID_D2D1SpotSpecular As GUID = Type(&hedae421e, &h7654, &h4a37, {&h9d, &hb8, &h71, &hac, &hc1, &hbe, &hb3, &hc1})
Dim Shared CLSID_D2D1Straighten As GUID = Type(&h4da47b12, &h79a3, &h4fb0, {&h82, &h37, &hbb, &hc3, &hb2, &ha4, &hde, &h08})
Dim Shared CLSID_D2D1TableTransfer As GUID = Type(&h5bf818c3, &h5e43, &h48cb, {&hb6, &h31, &h86, &h83, &h96, &hd6, &ha1, &hd4})
Dim Shared CLSID_D2D1TemperatureAndTint As GUID = Type(&h89176087, &h8AF9, &h4A08, {&hAE, &hB1, &h89, &h5F, &h38, &hDB, &h17, &h66})
Dim Shared CLSID_D2D1Tile As GUID = Type(&hb0784138, &h3b76, &h4bc5, {&hb1, &h3b, &h0f, &ha2, &had, &h02, &h65, &h9f})
Dim Shared CLSID_D2D1Tint As GUID = Type(&h36312b17, &hf7dd, &h4014, {&h91, &h5d, &hff, &hca, &h76, &h8c, &hf2, &h11})
Dim Shared CLSID_D2D1Turbulence As GUID = Type(&hcf2bb6ae, &h889a, &h4ad7, {&hba, &h29, &ha2, &hfd, &h73, &h2c, &h9f, &hc9})
Dim Shared CLSID_D2D1UnPremultiply As GUID = Type(&hfb9ac489, &had8d, &h41ed, {&h99, &h99, &hbb, &h63, &h47, &hd1, &h10, &hf7})
Dim Shared CLSID_D2D1Vignette As GUID = Type(&hc00c40be, &h5e67, &h4ca3, {&h95, &hb4, &hf4, &hb0, &h2c, &h11, &h51, &h35})

Dim Shared CLSID_D2D1PixelShader As GUID = Type(&HF6C2D3A1, &H8D05, &H4E39, {&H9F, &H6B, &H07, &HB1, &HEB, &HD6, &HB2, &HA7})

' ============================================================================
' Enumerations
' ============================================================================

Enum D2D1_BORDER_MODE
    D2D1_BORDER_MODE_SOFT = 0
    D2D1_BORDER_MODE_HARD = 1
    D2D1_BORDER_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_2DAFFINETRANSFORM_PROP
    D2D1_2DAFFINETRANSFORM_PROP_INTERPOLATION_MODE = 0
    D2D1_2DAFFINETRANSFORM_PROP_BORDER_MODE = 1
    D2D1_2DAFFINETRANSFORM_PROP_TRANSFORM_MATRIX = 2
    D2D1_2DAFFINETRANSFORM_PROP_SHARPNESS = 3
    D2D1_2DAFFINETRANSFORM_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_LINEAR = 1
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_CUBIC = 2
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_ANISOTROPIC = 4
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5
    D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_3DPERSPECTIVETRANSFORM_PROP
    D2D1_3DPERSPECTIVETRANSFORM_PROP_INTERPOLATION_MODE = 0
    D2D1_3DPERSPECTIVETRANSFORM_PROP_BORDER_MODE = 1
    D2D1_3DPERSPECTIVETRANSFORM_PROP_DEPTH = 2
    D2D1_3DPERSPECTIVETRANSFORM_PROP_PERSPECTIVE_ORIGIN = 3
    D2D1_3DPERSPECTIVETRANSFORM_PROP_LOCAL_OFFSET = 4
    D2D1_3DPERSPECTIVETRANSFORM_PROP_GLOBAL_OFFSET = 5
    D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION_ORIGIN = 6
    D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION = 7
    D2D1_3DPERSPECTIVETRANSFORM_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_LINEAR = 1
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_CUBIC = 2
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_ANISOTROPIC = 4
    D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_COMPOSITE_PROP
    D2D1_COMPOSITE_PROP_MODE = 0
    D2D1_COMPOSITE_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_CROP_PROP
    D2D1_CROP_PROP_RECT = 0
    D2D1_CROP_PROP_BORDER_MODE = 1
    D2D1_CROP_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_BLEND_MODE
    D2D1_BLEND_MODE_MULTIPLY = 0
    D2D1_BLEND_MODE_SCREEN = 1
    D2D1_BLEND_MODE_DARKEN = 2
    D2D1_BLEND_MODE_LIGHTEN = 3
    D2D1_BLEND_MODE_DISSOLVE = 4
    D2D1_BLEND_MODE_COLOR_BURN = 5
    D2D1_BLEND_MODE_LINEAR_BURN = 6
    D2D1_BLEND_MODE_DARKER_COLOR = 7
    D2D1_BLEND_MODE_LIGHTER_COLOR = 8
    D2D1_BLEND_MODE_COLOR_DODGE = 9
    D2D1_BLEND_MODE_LINEAR_DODGE = 10
    D2D1_BLEND_MODE_OVERLAY = 11
    D2D1_BLEND_MODE_SOFT_LIGHT = 12
    D2D1_BLEND_MODE_HARD_LIGHT = 13
    D2D1_BLEND_MODE_VIVID_LIGHT = 14
    D2D1_BLEND_MODE_LINEAR_LIGHT = 15
    D2D1_BLEND_MODE_PIN_LIGHT = 16
    D2D1_BLEND_MODE_HARD_MIX = 17
    D2D1_BLEND_MODE_DIFFERENCE = 18
    D2D1_BLEND_MODE_EXCLUSION = 19
    D2D1_BLEND_MODE_HUE = 20
    D2D1_BLEND_MODE_SATURATION = 21
    D2D1_BLEND_MODE_COLOR = 22
    D2D1_BLEND_MODE_LUMINOSITY = 23
    D2D1_BLEND_MODE_SUBTRACT = 24
    D2D1_BLEND_MODE_DIVISION = 25
    D2D1_BLEND_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_GAUSSIANBLUR_PROP
    D2D1_GAUSSIANBLUR_PROP_STANDARD_DEVIATION = 0
    D2D1_GAUSSIANBLUR_PROP_OPTIMIZATION = 1
    D2D1_GAUSSIANBLUR_PROP_BORDER_MODE = 2
    D2D1_GAUSSIANBLUR_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_GAUSSIANBLUR_OPTIMIZATION
    D2D1_GAUSSIANBLUR_OPTIMIZATION_SPEED = 0
    D2D1_GAUSSIANBLUR_OPTIMIZATION_BALANCED = 1
    D2D1_GAUSSIANBLUR_OPTIMIZATION_QUALITY = 2
    D2D1_GAUSSIANBLUR_OPTIMIZATION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_POINTSPECULAR_PROP
    D2D1_POINTSPECULAR_PROP_LIGHT_POSITION = 0
    D2D1_POINTSPECULAR_PROP_SPECULAR_EXPONENT = 1
    D2D1_POINTSPECULAR_PROP_SPECULAR_CONSTANT = 2
    D2D1_POINTSPECULAR_PROP_SURFACE_SCALE = 3
    D2D1_POINTSPECULAR_PROP_COLOR = 4
    D2D1_POINTSPECULAR_PROP_KERNEL_UNIT_LENGTH = 5
    D2D1_POINTSPECULAR_PROP_SCALE_MODE = 6
    D2D1_POINTSPECULAR_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_POINTSPECULAR_SCALE_MODE
    D2D1_POINTSPECULAR_SCALE_MODE_NEAREST_NEIGHBOR = 0
    D2D1_POINTSPECULAR_SCALE_MODE_LINEAR = 1
    D2D1_POINTSPECULAR_SCALE_MODE_CUBIC = 2
    D2D1_POINTSPECULAR_SCALE_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_POINTSPECULAR_SCALE_MODE_ANISOTROPIC = 4
    D2D1_POINTSPECULAR_SCALE_MODE_HIGH_QUALITY_CUBIC = 5
    D2D1_POINTSPECULAR_SCALE_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_ARITHMETICCOMPOSITE_PROP
    D2D1_ARITHMETICCOMPOSITE_PROP_COEFFICIENTS = 0
    D2D1_ARITHMETICCOMPOSITE_PROP_CLAMP_OUTPUT = 1
    D2D1_ARITHMETICCOMPOSITE_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SHADOW_PROP
    D2D1_SHADOW_PROP_BLUR_STANDARD_DEVIATION = 0
    D2D1_SHADOW_PROP_COLOR = 1
    D2D1_SHADOW_PROP_OPTIMIZATION = 2
    D2D1_SHADOW_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SHADOW_OPTIMIZATION
    D2D1_SHADOW_OPTIMIZATION_SPEED = 0
    D2D1_SHADOW_OPTIMIZATION_BALANCED = 1
    D2D1_SHADOW_OPTIMIZATION_QUALITY = 2
    D2D1_SHADOW_OPTIMIZATION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FLOOD_PROP
    D2D1_FLOOD_PROP_COLOR = 0
    D2D1_FLOOD_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_COLORMATRIX_PROP
    D2D1_COLORMATRIX_PROP_COLOR_MATRIX = 0
    D2D1_COLORMATRIX_PROP_ALPHA_MODE = 1
    D2D1_COLORMATRIX_PROP_CLAMP_OUTPUT = 2
    D2D1_COLORMATRIX_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_COLORMATRIX_ALPHA_MODE
    D2D1_COLORMATRIX_ALPHA_MODE_PREMULTIPLIED = 1
    D2D1_COLORMATRIX_ALPHA_MODE_STRAIGHT = 2
    D2D1_COLORMATRIX_ALPHA_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_BLEND_PROP
    D2D1_BLEND_PROP_MODE = 0
    D2D1_BLEND_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_BRIGHTNESS_PROP
    D2D1_BRIGHTNESS_PROP_WHITE_POINT = 0
    D2D1_BRIGHTNESS_PROP_BLACK_POINT = 1
    D2D1_BRIGHTNESS_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_DIRECTIONALBLUR_PROP
    D2D1_DIRECTIONALBLUR_PROP_STANDARD_DEVIATION = 0
    D2D1_DIRECTIONALBLUR_PROP_ANGLE = 1
    D2D1_DIRECTIONALBLUR_PROP_OPTIMIZATION = 2
    D2D1_DIRECTIONALBLUR_PROP_BORDER_MODE = 3
    D2D1_DIRECTIONALBLUR_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_DIRECTIONALBLUR_OPTIMIZATION
    D2D1_DIRECTIONALBLUR_OPTIMIZATION_SPEED = 0
    D2D1_DIRECTIONALBLUR_OPTIMIZATION_BALANCED = 1
    D2D1_DIRECTIONALBLUR_OPTIMIZATION_QUALITY = 2
    D2D1_DIRECTIONALBLUR_OPTIMIZATION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_HUEROTATION_PROP
    D2D1_HUEROTATION_PROP_ANGLE = 0
    D2D1_HUEROTATION_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SATURATION_PROP
    D2D1_SATURATION_PROP_SATURATION = 0
    D2D1_SATURATION_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SCALE_PROP
    D2D1_SCALE_PROP_SCALE = 0
    D2D1_SCALE_PROP_CENTER_POINT = 1
    D2D1_SCALE_PROP_INTERPOLATION_MODE = 2
    D2D1_SCALE_PROP_BORDER_MODE = 3
    D2D1_SCALE_PROP_SHARPNESS = 4
    D2D1_SCALE_PROP_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SCALE_INTERPOLATION_MODE
    D2D1_SCALE_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0
    D2D1_SCALE_INTERPOLATION_MODE_LINEAR = 1
    D2D1_SCALE_INTERPOLATION_MODE_CUBIC = 2
    D2D1_SCALE_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_SCALE_INTERPOLATION_MODE_ANISOTROPIC = 4
    D2D1_SCALE_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5
    D2D1_SCALE_INTERPOLATION_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum