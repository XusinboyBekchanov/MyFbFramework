'Code by UEZ build 2023-03-22
'https://www.freebasic.net/forum/viewtopic.php?p=297501&sid=9a4e5e2593ed84d46f36244aea17226b#p297501
'https://en.wikipedia.org/wiki/Color_difference
'http://www.brucelindbloom.com/index.html?Eqn_Lab_to_LCH.html
'http://www.easyrgb.com/index.php?X=MATH&H=09#text9

Const DE1976 = 0.0, DE1994_Textiles = 0.0, DE1994_GraphicArts = 0.0, DE2000 = 0.0, DECMC_11 = 0.0, DECMC_21 = 0.0, PI = Acos(-1), _
	 _16d116 = 16 / 116, _1d3 = 1 / 3, _2d3 = 2 / 3, _1d6 = 1 / 6, _1d24 = 1 / 2.4, _16d116 = 16 / 116
Type Lab
	As Double L, a, b
End Type

Union ColorRGB
	As ULong rgb
	Type
		As UByte b, g, r
	End Type
End Union

Type HSL
	As Double H, S, L
End Type

Type HSV
	As Double H, S, V
End Type

Type CMYK_
	As Double C, M, Y, K
End Type

Type XYZ
	As Double X, Y, Z
End Type


'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Type ColorConvert
	Public:
		Declare Constructor ()
		Declare Destructor ()
		Declare Function RGB2LAB(ByVal RGB1 As ColorRGB) As Lab
		Declare Function RGB2HSL(ByVal RGB1 As ColorRGB) As HSL
		Declare Function RGB2HSV(ByVal RGB1 As ColorRGB) As HSV
		Declare Function RGB2CMYK(ByVal RGB1 As ColorRGB) As CMYK_
		Declare Function RGB2XYZ(ByVal RGB1 As ColorRGB) As XYZ
		Declare Function HSL2RGB(ByVal HSL1 As HSL) As ColorRGB
		Declare Function HSV2RGB(ByVal HSV1 As HSV) As ColorRGB
		Declare Function XYZ2RGB(ByVal XYZ1 As XYZ) As ColorRGB
		Declare Function LAB2RGB(ByVal Lab1 As Lab) As ColorRGB
	Private:
		Declare Function hueToRgb(ByVal v1 As Double, ByVal v2 As Double, ByVal vh As Double) As Double
		Declare Function pivotRGB(ByVal n As Double) As Double
		Declare Function Pow(ByVal a As Double, ByVal b As Double) As Double
		Declare Function Min2(ByVal a As Double, ByVal b As Double) As Double
		Declare Function Max2(ByVal a As Double, ByVal b As Double) As Double
		Declare Function Min3(ByVal a As Double, ByVal b As Double, ByVal c As Double) As Double
		Declare Function Max3(ByVal a As Double, ByVal b As Double, ByVal c As Double) As Double
	As UByte a
End Type

Constructor ColorConvert()
End Constructor

Destructor ColorConvert()
End Destructor

'internal functions
Function ColorConvert.Pow(ByVal a As Double, ByVal b As Double) As Double
	Return a ^ b
End Function

Function ColorConvert.Min2(ByVal a As Double, ByVal b As Double) As Double
	Return IIf(a < b, a, b)
End Function

Function ColorConvert.Max2(ByVal a As Double, ByVal b As Double) As Double
	Return IIf(a > b, a, b)
End Function

Function ColorConvert.Min3(ByVal a As Double, ByVal b As Double, ByVal c As Double) As Double
	Return This.Min2(This.Min2(a, b), c)
End Function

Function ColorConvert.Max3(ByVal a As Double, ByVal b As Double, ByVal c As Double) As Double
	Return This.Max2(This.Max2(a, b), c)
End Function

Function ColorConvert.pivotRGB(Byval n As Double) As Double
	Return IIf(n > 0.04045, This.pow((n + 0.055) / 1.055, 2.4), n / 12.92) * 100
End Function

Function ColorConvert.hueToRgb(Byval v1 As Double, Byval v2 As Double, Byval vh As Double) As Double
	If (vh < 0.0) Then vh += 1.0
	If (vh > 1.0) Then vh -= 1.0
	If vh < _1d6 Then Return (v1 + (v2 - v1) * 6 * vh)
	If vh < 0.5 Then Return v2
	If vh < _2d3 Then Return (v1 + (v2 - v1) * (_2d3 - vh) * 6)
	Return v1
End Function

'color space converter
Function ColorConvert.RGB2LAB(Byval RGB1 As ColorRGB) As Lab
	Dim As Double r = RGB1.r / 255, g = RGB1.g / 255, b = RGB1.b / 255, x, y, z
	
	r = IIf(r > 0.04045, This.Pow((r + 0.055) / 1.055, 2.4), r / 12.92)
	g = IIf(g > 0.04045, This.Pow((g + 0.055) / 1.055, 2.4), g / 12.92)
	b = IIf(b > 0.04045, This.Pow((b + 0.055) / 1.055, 2.4), b / 12.92)
	
	x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
	y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000
	z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883

	x = Iif(x > 0.008856, This.Pow(x, _1d3), (7.787 * x) + _16d116)
	y = IIf(y > 0.008856, This.Pow(y, _1d3), (7.787 * y) + _16d116)
	z = IIf(z > 0.008856, This.Pow(z, _1d3), (7.787 * z) + _16d116)
	Dim As Lab Lab
	Lab.L = (116 * y) - 16
	Lab.a = 500 * (x - y)
	Lab.b = 200 * (y - z)
	Return Lab
End Function

Function ColorConvert.RGB2HSL(Byval RGB1 As ColorRGB) As HSL
	Dim As Double var_r = RGB1.r / 255, var_g = RGB1.g / 255, var_b = RGB1.b / 255 , _
				  H, S, L, var_Min, var_Max, del_Max, del_Max2, del_R, del_G, del_B
	
    var_Min = This.Min3(var_r, var_g, var_b)
    var_Max = This.Max3(var_r, var_g, var_b)
    del_Max = var_Max - var_Min
    L = (var_Max + var_Min) / 2	
    If del_Max = 0 Then
        H = 0
        S = 0
    Else
        S = Iif(L < 0.5, del_Max / (var_Max + var_Min), del_Max / (2 - var_Max - var_Min))
        del_Max2 = del_Max / 2
        del_R = (((var_Max - var_R) / 6) + del_Max2) / del_Max
        del_G = (((var_Max - var_G) / 6) + del_Max2) / del_Max
        del_B = (((var_Max - var_B) / 6) + del_Max2) / del_Max
        If (var_R = var_Max) Then
            H = del_B - del_G
        Elseif var_G = var_Max Then
            H = 0.333333333333333 + del_R - del_B
        Elseif var_B = var_Max Then
            H = 0.666666666666667 + del_G - del_R
        EndIf
        If H < 0 Then H += 1
        If H > 1 Then H -= 1
    Endif

	Return Type(H * 360, S, L)
End Function

Function ColorConvert.RGB2HSV(Byval RGB1 As ColorRGB) As HSV
	Dim As Double var_r = RGB1.r / 255, var_g = RGB1.g / 255, var_b = RGB1.b / 255 , _
				  H, S, V, var_Min, var_Max, del_Max, del_Max2, del_R, del_G, del_B
	
    var_Min = This.Min3(var_r, var_g, var_b)
    var_Max = This.Max3(var_r, var_g, var_b)
    del_Max = var_Max - var_Min
    V = var_Max	
    If del_Max = 0 Then
        H = 0
        S = 0
    Else
        S = del_Max / var_Max
        del_Max2 = del_Max / 2
        del_R = (((var_Max - var_r) / 6) + del_Max2) / del_Max
        del_G = (((var_Max - var_g) / 6) + del_Max2) / del_Max
        del_B = (((var_Max - var_b) / 6) + del_Max2) / del_Max
        If var_r = var_Max Then
            H = del_B - del_G
        ElseIf var_g = var_Max Then
            H = 0.333333333333333 + del_R - del_B
        ElseIf var_b = var_Max Then
            H = 0.666666666666667 + del_G - del_R
        EndIf
        If H < 0 Then H += 1
        If H > 1 Then H -= 1
    EndIf

	Return Type(H * 360, S, V)
End Function

Function ColorConvert.RGB2CMYK(ByVal RGB1 As ColorRGB) As CMYK_
	Dim As Double r = RGB1.r, g = RGB1.g, b = RGB1.b, _
				  C = 1 - (r / 255), M = 1 - (g / 255), Y = 1 - (b / 255), K = 1
				  
	If (C < K) Then K = C
	If (M < K) Then K = M
	If (Y < K) Then K = Y
	If (K = 1) Then 'Black only
		C = 0
		M = 0
		Y = 0
	Else
		C = (C - K) / (1 - K)
		M = (M - K) / (1 - K)
		Y = (Y - K) / (1 - K)
	EndIf
	Return Type(C, M, Y, K)
End Function

Function ColorConvert.RGB2XYZ(Byval RGB1 As ColorRGB) As XYZ
	Dim As Double r = This.pivotRgb(RGB1.r / 255), g = This.pivotRgb(RGB1.g / 255), b = This.pivotRgb(RGB1.b / 255)
	Return Type(r * 0.4124 + g * 0.3576 + b * 0.1805, r * 0.2126 + g * 0.7152 + b * 0.0722, r * 0.0193 + g * 0.1192 + b * 0.9505)
End Function

Function ColorConvert.HSL2RGB(Byval HSL1 As HSL) As ColorRGB
	Dim As Double r, g, b
	Dim As Double var_1 = 0, var_2 = 0
	HSL1.H /= 360
	If HSL1.S = 0 Then
		r = Fix(HSL1.L * 255)
		g = r
		b = r
	Else
		var_2 = Iif(HSL1.L < 0.5, HSL1.L * (1 + HSL1.S), HSL1.L + HSL1.S - HSL1.S * HSL1.L)
		var_1 = 2 * HSL1.L - var_2
		r = 255 * This.hueToRgb(var_1, var_2, HSL1.H + _1d3)
		g = 255 * This.hueToRgb(var_1, var_2, HSL1.H)
		b = 255 * This.hueToRgb(var_1, var_2, HSL1.H - _1d3)
	Endif
	Dim As ColorRGB c
	c.r = r : c.g = g : c.b = b
	Return c
End Function

Function ColorConvert.HSV2RGB(Byval HSV1 As HSV) As ColorRGB
	Dim As Double var_h, var_i, var_1, var_2, var_3, var_r, var_g, var_b
	Dim As Long i
	Dim As ColorRGB c
	If HSV1.S = 0 Then
		c.r = HSV1.V * 255
		c.g = c.r
		c.b = c.r
		Return c
	Endif
	HSV1.H /= 360
	var_h = HSV1.H * 6
	If (var_h = 6) Then var_h = 0
	var_i = Int(var_h)
	var_1 = HSV1.V * (1 - HSV1.S)
	var_2 = HSV1.V * (1 - HSV1.S * (var_h - var_i))
	var_3 = HSV1.V * (1 - HSV1.S * (1 - (var_h - var_i)))
	Select Case var_i
		Case 0
			var_r = HSV1.V
			var_g = var_3 
			var_b = var_1
		Case 1
			var_r = var_2
			var_g = HSV1.V
			var_b = var_1
		Case 2
			var_r = var_1
			var_g = HSV1.V
			var_b = var_3
		Case 3
			var_r = var_1
			var_g = var_2
			var_b = HSV1.V
		Case 4
			var_r = var_3
			var_g = var_1
			var_b = HSV1.V
		Case Else
			var_r = HSV1.V
			var_g = var_1
			var_b = var_2
	End Select
	c.r = var_r * 255
	c.g = var_g * 255
	c.b = var_b * 255
	Return c
End Function

Function ColorConvert.XYZ2RGB(Byval XYZ1 As XYZ) As ColorRGB
	Dim As Double var_X = XYZ1.X / 100, var_Y = XYZ1.Y / 100, var_Z = XYZ1.Z / 100, _
				  var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986, _
				  var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415, _
				  var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570
	If var_R > 0.0031308 Then
		var_R = 1.055 * (var_R ^ _1d24) - 0.055
	Else
		var_R = 12.92 * var_R
	Endif
	If var_G > 0.0031308 Then
		var_G = 1.055 * (var_G ^ _1d24) - 0.055
	Else
		var_G = 12.92 * var_G
	Endif
	If var_B > 0.0031308 Then
		var_B = 1.055 * (var_B ^ _1d24) - 0.055
	Else
		var_B = 12.92 * var_B
	Endif
	Dim As ColorRGB c
	c.r = var_r * 255
	c.g = var_g * 255
	c.b = var_b * 255
	Return c
End Function

Function ColorConvert.LAB2RGB(Byval Lab1 As Lab) As ColorRGB 'Lab -> XYZ -> RGB
	Dim As Double  var_Y = (Lab1.L + 16) / 116, var_X = Lab1.a / 500 + var_Y, var_Z = var_Y - Lab1.b / 200, x, y, z, var_R, var_G, var_B
	If This.Pow(var_Y, 3) > 0.008856 Then
		var_Y = pow(var_Y, 3)
	Else
		var_Y = (var_Y - _16d116) / 7.787
	Endif
	If This.Pow(var_X, 3) > 0.008856 Then
		var_X = pow(var_X, 3)
	Else
		var_X = (var_X - _16d116) / 7.787
	Endif
	If This.Pow(var_Z, 3) > 0.008856 Then
		var_Z = pow(var_Z, 3)
	Else
		var_Z = (var_Z - _16d116) / 7.787
	Endif
	x = 95.047 * var_X
	y = 100 * var_Y
	z = 108.883 * var_Z
	var_X = x / 100
	var_Y = Y / 100
	var_Z = Z / 100
	var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986
	var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415
	var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570
	If var_R > 0.0031308 Then
		var_R = 1.055 * (var_R ^ _1d24) - 0.055
	Else
		var_R = 12.92 * var_R
	Endif
	If var_G > 0.0031308 Then
		var_G = 1.055 * (var_G ^ _1d24) - 0.055
	Else
		var_G = 12.92 * var_G
	Endif
	If var_B > 0.0031308 Then
		var_B = 1.055 * (var_B ^ _1d24) - 0.055
	Else
		var_B = 12.92 * var_B
	Endif
	Dim As ColorRGB c
	c.r = var_r * 255
	c.g = var_g * 255
	c.b = var_b * 255
	Return c	
End Function

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Type ColorDiff
	Public:
		Declare Constructor ()
		Declare Destructor ()
	
		Declare Function DeltaE1976(Byval Lab1 As Lab, Byval Lab2 As Lab) As Double
		Declare Function DeltaE1994(Byval Lab1 As Lab, Byval Lab2 As Lab, Byval textiles As Boolean = False) As Double
		Declare Function DeltaE2000(Byval Lab1 As Lab, Byval Lab2 As Lab) As Double
		Declare Function DeltaECMC(Byval Lab1 As Lab, Byval Lab2 As Lab, Byval Lightness As Double = 1.0, Byval Chroma As Double = 1.0) As Double
		
		Declare Function Euclidean(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Double
		Declare Function Manhattan(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Ulong
		Declare Function Redmean(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Double
	As Ubyte a
End Type

Constructor ColorDiff()
End Constructor

Destructor ColorDiff()
End Destructor

'color difference calculator
Function ColorDiff.DeltaE1976(Byval Lab1 As Lab, Byval Lab2 As Lab) As Double
	Dim As Double delL = Lab1.L - Lab2.L, dela = Lab1.a - Lab2.a, delb = Lab1.b - Lab2.b
	Return Sqr(delL * delL + dela * dela + delb * delb)
End Function

Function ColorDiff.DeltaE1994(Byval Lab1 As Lab, Byval Lab2 As Lab, Byval textiles As Boolean = False) As Double
	Dim As Single k1 = Iif(textiles, 0.048, 0.045), k2 = Iif(textiles, 0.014, 0.015), kL =  Iif(textiles, 2, 1), kC = 1, kH = 1
	Dim As Double C1 = Sqr(Lab1.a * Lab1.a + Lab1.b * Lab1.b), C2 = Sqr(Lab2.a * Lab2.a + Lab2.b * Lab2.b), _
				  delA = Lab1.a - Lab2.a, delB = Lab1.b - Lab2.b, delC = C1 - C2, delH2 = delA * delA + delB * delB - delC * delC, delH = Iif(delH2 > 0.0, Sqr(delH2), 0), delL = Lab1.L - Lab2.L, _
				  sL = 1.0, sC = 1.0 + k1 * C1, sH = 1.0 + k2 * C1, _
				  vL = delL / (kL * sL), vC = delC / (kC * sC), vH = delH / (kH * sH)
	If textiles Then Return Sqr(vL * vL + vC * vC + vH * vH)
	Return Sqr(vL * vL + vC * vC + vH * vH)
End Function

Function ColorDiff.DeltaE2000(Byval Lab1 As Lab, Byval Lab2 As Lab) As Double
	Const kL = 1, kC = 1, kH = 1
	Dim As Double lBarPrime = 0.5 * (Lab1.L + Lab2.L), c1 = Sqr(Lab1.a * Lab1.a + Lab1.b * Lab1.b), c2 = Sqr(Lab2.a * Lab2.a + Lab2.b * Lab2.b), cBar = 0.5 * (c1 + c2), _
				  cBar7 = cBar * cBar * cBar * cBar * cBar * cBar * cBar, g = 0.5 * (1.0 - Sqr(cBar7 / (cBar7 + 6103515625))), a1Prime = Lab1.a * (1.0 + g), a2Prime = Lab2.a * (1.0 + g), _
				  c1Prime = Sqr(a1Prime * a1Prime + Lab1.b * Lab1.b), c2Prime = Sqr(a2Prime * a2Prime + Lab2.b * Lab2.b), cBarPrime = 0.5 * (c1Prime + c2Prime), h1Prime = (Atan2(Lab1.b, a1Prime) * 180.0) / PI, _
				  h2Prime = (Atan2(Lab2.b, a2Prime) * 180.0) / PI, hBarPrime, t, dLPrime, dCPrime, dHPrime, dH2Prime, sL, sC, sH, dTheta, cBarPrime7, rC, rT
	If h1Prime < 0.0 Then h1Prime += 360.0
	If h2Prime < 0.0 Then h2Prime += 360.0
	hBarPrime = Iif(Abs(h1Prime - h2Prime) > 180.0, (0.5 * (h1Prime + h2Prime + 360.0)), 0.5 * (h1Prime + h2Prime))
	t = 1.0 - _
			0.17 * Cos(PI * (      hBarPrime - 30.0) / 180.0) + _
			0.24 * Cos(PI * (2.0 * hBarPrime       ) / 180.0) + _
			0.32 * Cos(PI * (3.0 * hBarPrime +  6.0) / 180.0) - _
			0.20 * Cos(PI * (4.0 * hBarPrime - 63.0) / 180.0)
	If (Abs(h2Prime - h1Prime) <= 180.0) Then
		dhPrime = h2Prime - h1Prime
	Else
		dhPrime = IIf(h2Prime <= h1Prime, h2Prime - h1Prime + 360.0, h2Prime - h1Prime - 360.0)
	Endif
	dLPrime = Lab2.L - Lab1.L
	dCPrime = c2Prime - c1Prime
	dH2Prime = 2.0 * Sqr(c1Prime * c2Prime) * Sin(PI * (0.5 * dhPrime) / 180.0)
	sL = 1.0 + ((0.015 * (lBarPrime - 50.0) * (lBarPrime - 50.0)) / Sqr(20.0 + (lBarPrime - 50.0) * (lBarPrime - 50.0)))
	sC = 1.0 + 0.045 * cBarPrime
	sH = 1.0 + 0.015 * cBarPrime * t
	dTheta = 30.0 * Exp(-((hBarPrime - 275.0) / 25.0) * ((hBarPrime - 275.0) / 25.0))
	cBarPrime7 = cBarPrime * cBarPrime * cBarPrime * cBarPrime * cBarPrime * cBarPrime * cBarPrime
	rC = Sqr(cBarPrime7 / (cBarPrime7 + 6103515625.0))
	rT = -2.0 * rC * Sin(PI * (2.0 * dTheta) / 180.0)
	Return Sqr(	(dLPrime / (kL * sL)) * (dLPrime / (kL * sL)) + _
				(dCPrime / (kC * sC)) * (dCPrime / (kC * sC)) + _
				(dH2Prime / (kH * sH)) * (dH2Prime / (kH * sH)) + _
				(dCPrime / (kC * sC)) * (dH2Prime / (kH * sH)) * rT)
End Function

Function ColorDiff.DeltaECMC(Byval Lab1 As Lab, Byval Lab2 As Lab, Byval Lightness As Double = 1.0, Byval Chroma As Double = 1.0) As Double
	Dim As Double c1, c2, sl, sc, h1, t, c4, f, sh, delL, delA, delB, delC, dH2, v1, v2, v3
	c1 = Sqr(Lab1.a * Lab1.a + Lab1.b * Lab1.b)
	c2 = Sqr(Lab2.a * Lab2.a + Lab2.b * Lab2.b)
	sl = IIf(Lab1.L < 16.0, 0.511, (0.040975 * Lab1.L) / (1.0 + 0.01765 * Lab1.L))
	sc = (0.0638 * c1) / (1.0 + 0.0131 * c1) + 0.638
	h1 = IIf(c1 < 0.000001, 0.0, (Atan2(Lab1.b, Lab1.a) * 180.0) / PI)
	While h1 < 0
		h1 += 360.0
	Wend
	while h1 >= 360.0
		h1 -= 360.0
	Wend
	t = IIf((h1 >= 164.0) And (h1 <= 345.0), 0.56 + Abs(0.2 * Cos((PI * (h1 + 168.0)) / 180.0)), 0.36 + Abs(0.4 * Cos((PI * (h1 + 35.0)) / 180.0)))
	c4 = c1 * c1 * c1 * c1
	f = Sqr(c4 / (c4 + 1900.0))
	sh = sc * (f * t + 1.0 - f)
	delL = Lab1.L - Lab2.L
	delC = c1 - c2
	delA = Lab1.a - Lab2.a
	delB = Lab1.b - Lab2.b
	dH2 = delA * delA + delB * delB - delC * delC
	v1 = delL / (Lightness * sl)
	v2 = delC / (Chroma * sc)
	v3 = sh
	If Lightness = 2.0 Then Return Sqr(v1 * v1 + v2 * v2 + (dH2 / (v3 * v3)))
	Return Sqr(v1 * v1 + v2 * v2 + (dH2 / (v3 * v3)))
End Function

'color distance calculator
Function ColorDiff.Euclidean(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Double
	Dim As Long dR = RGB2.r - RGB1.r, dG = RGB2.g - RGB1.g, dB = RGB2.b - RGB1.b
	Return Sqr(dr * dr + dg * dg + db * db)
End Function

Function ColorDiff.Manhattan(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Ulong
	Return Abs(RGB1.r - RGB2.r) + Abs(RGB1.g - RGB2.g) + Abs(RGB1.b - RGB2.b)
End Function

Function ColorDiff.Redmean(Byval RGB1 As ColorRGB, Byval RGB2 As ColorRGB) As Double
	Dim As Double r = 0.5 * (RGB1.r + RGB2.r)
	Dim As Long dR = RGB2.r - RGB1.r, dG = RGB2.g - RGB1.g, dB = RGB2.b - RGB1.b
	Return Sqr((2 + (r / 256)) * dR * dR + 4 * dG * dG + (2 + (255 - r) / 256) * dB * dB)
End Function

