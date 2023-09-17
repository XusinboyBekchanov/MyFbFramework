'###############################################################################
'#  Graphics.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGraphics.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Object.bi"

'Namespace My.Sys.Drawing
#ifdef __USE_WINAPI__
	#define clScrollBar           GetSysColor(COLOR_SCROLLBAR)
	#define clBackground          GetSysColor(COLOR_BACKGROUND)
	#define clActiveCaption       GetSysColor(COLOR_ACTIVECAPTION)
	#define clInactiveCaption     GetSysColor(COLOR_INACTIVECAPTION)
	#define clMenu                GetSysColor(COLOR_MENU)
	#define clWindow              GetSysColor(COLOR_WINDOW)
	#define clWindowFrame         GetSysColor(COLOR_WINDOWFRAME)
	#define clMenuText            GetSysColor(COLOR_MENUTEXT)
	#define clWindowText          GetSysColor(COLOR_WINDOWTEXT)
	#define clCaptionText         GetSysColor(COLOR_CAPTIONTEXT)
	#define clActiveBorder        GetSysColor(COLOR_ACTIVEBORDER)
	#define clInactiveBorder      GetSysColor(COLOR_INACTIVEBORDER)
	#define clAppWorkSpace        GetSysColor(COLOR_APPWORKSPACE)
	#define clHighlight           GetSysColor(COLOR_HIGHLIGHT)
	#define clHighlightText       GetSysColor(COLOR_HIGHLIGHTTEXT)
	#define clBtnFace             GetSysColor(COLOR_BTNFACE)
	#define clBtnShadow           GetSysColor(COLOR_BTNSHADOW)
	#define clGrayText            GetSysColor(COLOR_GRAYTEXT)
	#define clBtnText             GetSysColor(COLOR_BTNTEXT)
	#define clInactiveCaptionText GetSysColor(COLOR_INACTIVECAPTIONTEXT)
	#define clBtnHighlight        GetSysColor(COLOR_BTNHIGHLIGHT)
	#define cl3DDkShadow          GetSysColor(COLOR_3DDKSHADOW)
	#define cl3DLight             GetSysColor(COLOR_3DLIGHT)
	#define clInfoText            GetSysColor(COLOR_INFOTEXT)
	#define clInfoBk              GetSysColor(COLOR_INFOBK)
#else
	#define clScrollBar           &H000000
	#define clBackground          &H000000
	#define clActiveCaption       &H000000
	#define clInactiveCaption     &H000000
	#define clMenu                &H000000
	#define clWindow              &H000000
	#define clWindowFrame         &H000000
	#define clMenuText            &H000000
	#define clWindowText          &H000000
	#define clCaptionText         &H000000
	#define clActiveBorder        &H000000
	#define clInactiveBorder      &H000000
	#define clAppWorkSpace        &H000000
	#define clHighlight           &H00A5FF
	#define clHighlightText       &HFFFFFF
	#define clBtnFace             &H808080
	#define clBtnShadow           &HC0C0C0
	#define clGrayText            &H000000
	#define clBtnText             &H000000
	#define clInactiveCaptionText &H000000
	#define clBtnHighlight        &H000000
	#define cl3DDkShadow          &H000000
	#define cl3DLight             &H000000
	#define clInfoText            &H000000
	#define clInfoBk              &H000000
#endif

#define clAliceBlue                &HFFF8F0   '   RGB(240, 248, 255)   '爱丽丝蓝
#define clAntiqueWhite             &HD7EBFA   '   RGB(250, 235, 215)   '古董白
#define clAqua                     &HFFFF00   '   RGB(0, 255, 255)   '浅绿色(水色)
#define clAquamarine               &HD4FF7F   '   RGB(127, 255, 212)   '宝石碧绿
#define clAzure                    &HFFFFF0   '   RGB(240, 255, 255)   '蔚蓝色
#define clBeige                    &HDCF5F5   '   RGB(245, 245, 220)   '米色/灰棕色
#define clBisque                   &HC4E4FF   '   RGB(255, 228, 196)   '陶坯黄
#define clBlack                    &H000000   '   RGB(0, 0, 0)   '纯黑
#define clBlanchedAlmond           &HCDEBFF   '   RGB(255, 235, 205)   '白杏色
#define clBlue                     &HFF0000   '   RGB(0, 0, 255)   '纯蓝
#define clBlueViolet               &HE22B8A   '   RGB(138, 43, 226)   '蓝紫罗兰
#define clBrown                    &H2A2AA5   '   RGB(165, 42, 42)   '棕色
#define clBurlyWood                &H87B8DE   '   RGB(222, 184, 135)   '硬木色
#define clCadetBlue                &HA09E5F   '   RGB(95, 158, 160)   '军兰色(军服蓝)
#define clChartreuse               &H00FF7F   '   RGB(127, 255, 0)   '黄绿色(查特酒绿)
#define clChocolate                &H1E69D2   '   RGB(210, 105, 30)   '巧克力色
#define clCoral                    &H507FFF   '   RGB(255, 127, 80)   '珊瑚
#define clCornflowerBlue           &HED9564   '   RGB(100, 149, 237)   '矢车菊蓝
#define clCornsilk                 &HDCF8FF   '   RGB(255, 248, 220)   '玉米丝色
#define clCrimson                  &H3C14DC   '   RGB(220, 20, 60)   '深红(猩红)
#define clCyan                     &HFFFF00   '   RGB(0, 255, 255)   '青色
#define clDarkBlue                 &H8B0000   '   RGB(0, 0, 139)   '暗蓝色
#define clDarkCyan                 &H8B8B00   '   RGB(0, 139, 139)   '暗青色
#define clDarkGoldenrod            &H0B86B8   '   RGB(184, 134, 11)   '暗金菊黄
#define clDarkGray                 &HA9A9A9   '   RGB(169, 169, 169)   '深灰色
#define clDarkGreen                &H006400   '   RGB(0, 100, 0)   '暗绿色
#define clDarkKhaki                &H6BB7BD   '   RGB(189, 183, 107)   '暗黄褐色(深卡叽布)
#define clDarkMagenta              &H8B008B   '   RGB(139, 0, 139)   '深洋红
#define clDarkOliveGreen           &H2F6B55   '   RGB(85, 107, 47)   '暗橄榄绿
#define clDarkOrange               &H008CFF   '   RGB(255, 140, 0)   '深橙色
#define clDarkOrchid               &HCC3299   '   RGB(153, 50, 204)   '暗兰花紫
#define clDarkRed                  &H00008B   '   RGB(139, 0, 0)   '深红色
#define clDarkSalmon               &H7A96E9   '   RGB(233, 150, 122)   '深鲜肉/鲑鱼色
#define clDarkSeaGreen             &H8FBC8F   '   RGB(143, 188, 143)   '暗海洋绿
#define clDarkSlateBlue            &H8B3D48   '   RGB(72, 61, 139)   '暗灰蓝色(暗板岩蓝)
#define clDarkSlateGray            &H4F4F2F   '   RGB(47, 79, 79)   '暗瓦灰色(暗石板灰)
#define clDarkTurquoise            &HD1CE00   '   RGB(0, 206, 209)   '暗绿宝石
#define clDarkViolet               &HD30094   '   RGB(148, 0, 211)   '暗紫罗兰
#define clDeepPink                 &H9314FF   '   RGB(255, 20, 147)   '深粉红
#define clDeepSkyBlue              &HFFBF00   '   RGB(0, 191, 255)   '深天蓝
#define clDefault                  &H20000000
#define clDimGray                  &H696969   '   RGB(105, 105, 105)   '暗淡的灰色
#define clDkGray                   &H808080
#define clDodgerBlue               &HFF901E   '   RGB(30, 144, 255)   '闪兰色(道奇蓝)
#define clFireBrick                &H2222B2   '   RGB(178, 34, 34)   '火砖色(耐火砖)
#define clFloralWhite              &HF0FAFF   '   RGB(255, 250, 240)   '花的白色
#define clForestGreen              &H228B22   '   RGB(34, 139, 34)   '森林绿
#define clFuchsia                  &HFF00FF   '   RGB(255, 0, 255)   '紫红(灯笼海棠)
#define clGainsboro                &HDCDCDC   '   RGB(220, 220, 220)   '淡灰色(庚斯博罗灰)
#define clGhostWhite               &HFFF8F8   '   RGB(248, 248, 255)   '幽灵白
#define clGold                     &H00D7FF   '   RGB(255, 215, 0)   '金色
#define clGoldenrod                &H20A5DA   '   RGB(218, 165, 32)   '金菊黄
#define clGray                     &H808080   '   RGB(128, 128, 128)   '灰色
#define clGreen                    &H008000   '   RGB(0, 128, 0)   '纯绿
#define clGreenYellow              &H2FFFAD   '   RGB(173, 255, 47)   '绿黄色
#define clHoneydew                 &HF0FFF0   '   RGB(240, 255, 240)   '蜜色(蜜瓜色)
#define clHotPink                  &HB469FF   '   RGB(255, 105, 180)   '热情的粉红
#define clIndianRed                &H5C5CCD   '   RGB(205, 92, 92)   '印度红
#define clIndigo                   &H82004B   '   RGB(75, 0, 130)   '靛青/紫兰色
#define clIvory                    &HF0FFFF   '   RGB(255, 255, 240)   '象牙色
#define clKhaki                    &H8CE6F0   '   RGB(240, 230, 140)   '黄褐色(卡叽布)
#define clLavender                 &HFAE6E6   '   RGB(230, 230, 250)   '淡紫色(熏衣草淡紫)
#define clLavenderBlush            &HF5F0FF   '   RGB(255, 240, 245)   '淡紫红
#define clLawnGreen                &H00FC7C   '   RGB(124, 252, 0)   '草绿色(草坪绿_
#define clLemonChiffon             &HCDFAFF   '   RGB(255, 250, 205)   '柠檬绸
#define clLightBlue                &HE6D8AD   '   RGB(173, 216, 230)   '亮蓝
#define clLightCoral               &H8080F0   '   RGB(240, 128, 128)   '淡珊瑚色
#define clLightCyan                &HFFFFE0   '   RGB(224, 255, 255)   '淡青色
#define clLightGoldenrodYellow     &HD2FAFA   '   RGB(250, 250, 210)   '亮菊黄
#define clLightGreen               &H90EE90   '   RGB(144, 238, 144)   '淡绿色
#define clLightGrey                &HD3D3D3   '   RGB(211, 211, 211)   '浅灰色
#define clLightPink                &HC1B6FF   '   RGB(255, 182, 193)   '浅粉红
#define clLightSalmon              &H7AA0FF   '   RGB(255, 160, 122)   '浅鲑鱼肉色
#define clLightSeaGreen            &HAAB220   '   RGB(32, 178, 170)   '浅海洋绿
#define clLightSkyBlue             &HFACE87   '   RGB(135, 206, 250)   '亮天蓝色
#define clLightSlateGray           &H998877   '   RGB(119, 136, 153)   '亮蓝灰(亮石板灰)
#define clLightSteelBlue           &HDEC4B0   '   RGB(176, 196, 222)   '亮钢蓝
#define clLightYellow              &HE0FFFF   '   RGB(255, 255, 224)   '浅黄色
#define clLime                     &H00FF00   '   RGB(0, 255, 0)   '闪光绿
#define clLimeGreen                &H32CD32   '   RGB(50, 205, 50)   '闪光深绿
#define clLinen                    &HE6F0FA   '   RGB(250, 240, 230)   '亚麻布
#define clLtGray                   &HC0C0C0
#define clMagenta                  &HFF00FF   '   RGB(255, 0, 255)   '洋红(玫瑰红)
#define clMaroon                   &H000080   '   RGB(128, 0, 0)   '栗色
#define clMediumAquamarine         &HAACD66   '   RGB(102, 205, 170)   '中宝石碧绿
#define clMediumBlue               &HCD0000   '   RGB(0, 0, 205)   '中蓝色
#define clMediumOrchid             &HD355BA   '   RGB(186, 85, 211)   '中兰花紫
#define clMediumPurple             &HDB7093   '   RGB(147, 112, 219)   '中紫色
#define clMediumSeaGreen           &H71B33C   '   RGB(60, 179, 113)   '中海洋绿
#define clMediumSlateBlue          &HEE687B   '   RGB(123, 104, 238)   '中暗蓝色(中板岩蓝)
#define clMediumSpringGreen        &H9AFA00   '   RGB(0, 250, 154)   '中春绿色
#define clMediumTurquoise          &HCCD148   '   RGB(72, 209, 204)   '中绿宝石
#define clMediumVioletRed          &H8515C7   '   RGB(199, 21, 133)   '中紫罗兰红
#define clMidnightBlue             &H701919   '   RGB(25, 25, 112)   '午夜蓝
#define clMintCream                &HFAFFF5   '   RGB(245, 255, 250)   '薄荷奶油
#define clMistyRose                &HE1E4FF   '   RGB(255, 228, 225)   '浅玫瑰色(薄雾玫瑰)
#define clMoccasin                 &HB5E4FF   '   RGB(255, 228, 181)   '鹿皮色(鹿皮靴)
#define clNavajoWhite              &HADDEFF   '   RGB(255, 222, 173)   '纳瓦白(土著白)
#define clNavy                     &H800000   '   RGB(0, 0, 128)   '海军蓝
#define clNone                     &H1FFFFFFF
#define clOldLace                  &HE6F5FD   '   RGB(253, 245, 230)   '老花色(旧蕾丝)
#define clOlive                    &H008080   '   RGB(128, 128, 0)   '橄榄
#define clOliveDrab                &H238E6B   '   RGB(107, 142, 35)   '橄榄褐色
#define clOrange                   &H00A5FF   '   RGB(255, 165, 0)   '橙色
#define clOrangeRed                &H0045FF   '   RGB(255, 69, 0)   '橙红色
#define clOrchid                   &HD670DA   '   RGB(218, 112, 214)   '暗紫色(兰花紫)
#define clPaleGoldenrod            &HAAE8EE   '   RGB(238, 232, 170)   '灰菊黄(苍麒麟色)
#define clPaleGreen                &H98FB98   '   RGB(152, 251, 152)   '弱绿色
#define clPaleTurquoise            &HEEEEAF   '   RGB(175, 238, 238)   '弱绿宝石
#define clPaleVioletRed            &H9370DB   '   RGB(219, 112, 147)   '弱紫罗兰红
#define clPapayaWhip               &HD5EFFF   '   RGB(255, 239, 213)   '番木色(番木瓜)
#define clPeachPuff                &HB9DAFF   '   RGB(255, 218, 185)   '桃肉色
#define clPeru                     &H3F85CD   '   RGB(205, 133, 63)   '秘鲁色
#define clPink                     &HCBC0FF   '   RGB(255, 192, 203)   '粉红
#define clPlum                     &HDDA0DD   '   RGB(221, 160, 221)   '洋李色(李子紫)
#define clPowderBlue               &HE6E0B0   '   RGB(176, 224, 230)   '粉蓝色(火药青)
#define clPurple                   &H800080   '   RGB(128, 0, 128)   '紫色
#define clRed                      &H0000FF   '   RGB(255, 0, 0)   '纯红
#define clRosyBrown                &H8F8FBC   '   RGB(188, 143, 143)   '玫瑰棕色
#define clRoyalBlue                &HE16941   '   RGB(65, 105, 225)   '皇家蓝/宝蓝
#define clSaddleBrown              &H13458B   '   RGB(139, 69, 19)   '重褐色(马鞍棕色)
#define clSalmon                   &H7280FA   '   RGB(250, 128, 114)   '鲜肉/鲑鱼色
#define clSandyBrown               &H60A4F4   '   RGB(244, 164, 96)   '沙棕色
#define clSeaGreen                 &H578B2E   '   RGB(46, 139, 87)   '海洋绿
#define clSeashell                 &HEEF5FF   '   RGB(255, 245, 238)   '海贝壳
#define clSienna                   &H2D52A0   '   RGB(160, 82, 45)   '黄土赭色
#define clSilver                   &HC0C0C0   '   RGB(192, 192, 192)   '银灰色
#define clSkyBlue                  &HEBCE87   '   RGB(135, 206, 235)   '天蓝色
#define clSlateBlue                &HCD5A6A   '   RGB(106, 90, 205)   '石蓝色(板岩蓝)
#define clSlateGray                &H908070   '   RGB(112, 128, 144)   '灰石色(石板灰)
#define clSnow                     &HFAFAFF   '   RGB(255, 250, 250)   '雪白色
#define clSpringGreen              &H7FFF00   '   RGB(0, 255, 127)   '春绿色
#define clSteelBlue                &HB48246   '   RGB(70, 130, 180)   '钢蓝/铁青
#define clTan                      &H8CB4D2   '   RGB(210, 180, 140)   '茶色
#define clTeal                     &H808000   '   RGB(0, 128, 128)   '水鸭色
#define clThistle                  &HD8BFD8   '   RGB(216, 191, 216)   '蓟色
#define clTomato                   &H4763FF   '   RGB(255, 99, 71)   '番茄红
#define clTurquoise                &HD0E040   '   RGB(64, 224, 208)   '绿宝石
#define clViolet                   &HEE82EE   '   RGB(238, 130, 238)   '紫罗兰
#define clWheat                    &HB3DEF5   '   RGB(245, 222, 179)   '浅黄色(小麦色)
#define clWhite                    &HFFFFFF   '   RGB(255, 255, 255)   '纯白
#define clWhiteSmoke               &HF5F5F5   '   RGB(245, 245, 245)   '白烟
#define clYellow                   &H00FFFF   '   RGB(255, 255, 0)   '纯黄
#define clYellowGreen              &H32CD9A   '   RGB(154, 205, 50)   '黄绿色

Declare Function ColorToRGB(FColor As Integer) As Integer
Declare Function RGBAToBGR(FColor As UInteger) As Integer
Declare Function IsDarkColor(lColor As Long) As Boolean
Declare Function ShiftColor(clrFirst As Long, clrSecond As Long, lAlpha As Long) As Long
Declare Function RGBtoARGB(RGBColor As ULong, Opacity As Long) As ULong
Declare Function BGRToRGBA(FColor As UInteger) As UInteger
Declare Function GetRed(FColor As Long) As Integer
Declare Function GetGreen(FColor As Long) As Integer
Declare Function GetBlue(FColor As Long) As Integer
#ifndef __USE_WINAPI__
	#ifndef BGR
		#define BGR(r, g, b) (Cast(UByte, (r)) Or (Cast(UShort, Cast(UByte, (g))) Shl 8)) Or (Cast(UShort, Cast(UByte, (b))) Shl 16)
	#endif
#endif
#define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CUInt( c )        And 255 )
#define RGBA_A( c ) ( CUInt( c ) Shr 24         )


'End Namespace

#include once "Pen.bi"
#include once "Brush.bi"
#include once "Icon.bi"
#include once "Cursor.bi"
#include once "Bitmap.bi"
#include once "Font.bi"

#ifndef __USE_MAKE__
	#include once "Graphics.bas"
#endif
