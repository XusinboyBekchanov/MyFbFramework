'SimpleVariantPlus.bi: a "lean and mean" (not library-dependent) LateBound-Helper-Module for FreeBasic
'Author:      Olaf Schmidt (June 2016)
'Updated by Xusinboy Bekchanov to support 64-bit (August 2020)
'The Vartype-Letters, as used for the ByName...-Methods are as follows:
'    u: 8BitU-Integer(FB UByte)
'    i: 16Bit-Integer(FB Short)
'    l: 32Bit-Integer(FB Long)
'    c: 64Bit-Integer(FB LongInt, mapped between 64Bit-FB-Int and -OLEVariant-Currency)
'    b: 16Bit-Boolean(FB Boolean, mapped between 8Bit-FB and 16Bit-OLEVariant-Booleans)
'    f: 32Bit-FlPoint(FB Single)
'    d: 64Bit-FlPoint(FB Double)
'    t: 64BitDateTime(FB Double)
'    s: 8Bit-per-Char(FB String)  !!! note, that only in normal ANSI-FB-Source-Modules, String-Literals can be passed as "s"...
'    w: 16Bit-per-Chr(FB WString) !!! ...in FB-Source-Modules that are Unicode, String-Literals need to be passed as "w" instead
'    v: OleVariant (which always need to be passed with their VarPtr -> @VariantVariable
'When used in the TypeChars-Param of the CallByName-Func, an UpperCase-Letter signifies
'"ByRef"-passing (the FB-Variable needs to be prefixed by an @ in these cases)

#include once "vbcompat.bi"
#include once "windows.bi"
#include once "win/ole2.bi"
#include once "crt/string.bi"

#ifdef __FB_WIN32__ 'this is necessary, because FB maps the original FB-Long-Def to Boolean somehow (remove when Fix is available in the Compiler)
	#undef  Long
	#define Long Integer '...though it should not do any harm to leave it as is... on Win32 it's the same BitLength (+ we filtered with the #IfDef)
	#undef  CLng
	#define CLng CInt 'same thing here - a redefinition is necessary to work around the FB-Win32-Compiler-Bug
	#undef Call 'to allow usage of that KeyWord as an UDT-Method (it's not used anyways in lang -fb)
#endif

'the following Const is used in the (Variant)Conversions from BSTRs to FB-Strings
Dim Shared DefaultCodePage_StringConv As UINT
#ifdef UNICODE
	DefaultCodePage_StringConv = CP_UTF8 'an 8Bit-FB-String will hold an UTF8-Stream when a vbVariant is casted to it
#else
	DefaultCodePage_StringConv = CP_ACP 'that conforms to the normal ANSI-Conversion
#endif

'the Const below is relevant for the Variant-Conversions (Strings <-> Numbers or DateValues) - we avoid LOCALE_USER_DEFAULT,
'since that would convert e.g. a DoubleValue of 1.1 to a String-Representation of 1,1 on a german system, instead LOCALE_INVARIANT ...
Const DefaultLocale_VariantConv As Long = LOCALE_INVARIANT '...conforms to FB-StringConv-Representations of Dates and rational Numbers

Type tCOMErr
	Number As UINT
	Description As String
End Type
Dim Shared COMErr As tCOMErr, EInfo As tagEXCEPINFO, ShowCOMErrors As Boolean = True

Dim Shared Done As Boolean 'anything COM-related needs to CoInitialize... (shell32 and comctl32 are preloaded, to play nicely with Manifested Apps)
If Not Done Then Done = True: CoInitializeEx(0, 2): DyLibLoad("shell32.dll"): DyLibLoad("comctl32.dll")

Function AppName() As String
	Static S As String
	If Len(S) = 0 Then S = Command(0):S = Mid(S, InStrRev(S, "\") + 1): S = Left(S, Len(S) - 4)
	Return S
End Function
'One of the MFF mark
#ifndef APP_TITLE
	Function MsgBox cdecl Overload (ByVal Msg As LPCWSTR, ByVal Flags As Long = MB_ICONINFORMATION) As Long
		Return MessageBoxW(GetActiveWindow, Msg, AppName, Flags)
	End Function
#endif
Private Function HandleCOMErr(ByVal HRes As HRESULT, ByVal MethodName As LPOLESTR) As HRESULT
	Static Msg As WString Ptr: If Msg = NULL Then Msg = CAllocate(8192 + 2)
	
	Function = HRes
	If HRes = DISP_E_EXCEPTION Then
		COMErr.Number = EInfo.scode
		COMErr.Description= "Err(&H" & Hex(HRes) & ") in " & *Cast(WString Ptr, EInfo.bstrSource) & ", whilst calling: " & *Cast(WString Ptr, MethodName) & Chr(10) & *Cast(WString Ptr, EInfo.bstrDescription)
	ElseIf HRes Then
		FormatMessageW FORMAT_MESSAGE_FROM_SYSTEM Or FORMAT_MESSAGE_IGNORE_INSERTS, NULL, HRes, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), Msg, 4096, NULL
		COMErr.Number = HRes
		COMErr.Description= "Err(&H" & Hex(HRes) & ") in SimpleVariant.bi, whilst calling: " & *Cast(WString Ptr, MethodName) & Chr(10) & *Msg
	End If
	If CBool(HRes) And ShowCOMErrors Then MsgBox COMErr.Description
End Function

'the usual Instantiation-Helper for COM-Objects which are known in the Win-Registry (e.g. CreateObject("Scripting.Dictionary")
Function CreateObject(ByVal ProgID As LPCOLESTR) As tagVARIANT
	If Not Done Then Done = True: CoInitializeEx(0, 2): DyLibLoad("shell32.dll"): DyLibLoad("comctl32.dll")
	
	COMErr.Number = 0
	Dim CLSID As CLSID, RetVal As tagVARIANT
	If HandleCOMErr(CLSIDFromProgID(ProgID, @CLSID), "CLSIDFromProgID") Then Return RetVal
	If HandleCOMErr(CoCreateInstance(@CLSID, NULL, CLSCTX_SERVER, @IID_IDispatch, @RetVal.pdispVal), "CreateObject") Then Return RetVal
	RetVal.vt = VT_DISPATCH
	Return RetVal
End Function

'but here's a helper-function to create COM-Objects regfree, in case the user provided a *.manifest-File (and placed it beside the COM-Dll-File)
Function CreateObjectRegFree(ProgID As WString Ptr, ManifestFileName As WString Ptr) As tagVARIANT
	Static ACW As ACTCTXW
	ACW.cbSize = Len(ACW)
	ACW.lpSource = ManifestFileName
	
	COMErr.Number = 0
	
	Dim hActCtx As HANDLE, Cookie As ULONG_PTR
	hActCtx = CreateActCtxW(@ACW)
	If (hActCtx = INVALID_HANDLE_VALUE) Then
		COMErr.Number = &H80020009
		COMErr.Description = "Couldn't create ActCtx from Manifest: " & *ManifestFileName
		If ShowCOMErrors Then MsgBox COMErr.Description
		Exit Function
	End If
	
	If ActivateActCtx(hActCtx, @Cookie) Then
		Dim OrigDir As String, DllPath As String = Left(*ManifestFileName, InStrRev(*ManifestFileName, "\"))
		OrigDir = CurDir()
		ChDir DllPath
		Function = CreateObject(ProgID)
		ChDir OrigDir
		DeactivateActCtx 0, Cookie
	Else
		COMErr.Number = &H80020009
		COMErr.Description = "Couldn't activate ActCtx from Manifest: " & *ManifestFileName
		If ShowCOMErrors Then MsgBox COMErr.Description
	End If
	
	ReleaseActCtx hActCtx
End Function

Function BSTR2S cdecl (ByVal BS As Const BSTR, ByVal CodePage As UINT = DefaultCodePage_StringConv) As String
	Dim BytesNeeded As UINT, S As String
	BytesNeeded = WideCharToMultiByte(CodePage, 0, BS, SysStringLen(BS), 0, 0, 0, 0)
	S = String(BytesNeeded, 0)
	WideCharToMultiByte CodePage, 0, BS, SysStringLen(BS), StrPtr(S), BytesNeeded, 0, 0
	Return S
End Function
Function S2BSTR cdecl (S As Const String, ByVal CodePage As UINT = DefaultCodePage_StringConv) As BSTR 'the caller is responsible for freeing the returned BSTR per SysFreeString
	Dim WCharsNeeded As UINT, BS As BSTR
	WCharsNeeded = MultiByteToWideChar(CodePage, 0, StrPtr(S), Len(S), 0, 0)
	BS = SysAllocStringLen(BS, WCharsNeeded)
	MultiByteToWideChar CodePage, 0, StrPtr(S), Len(S), BS, WCharsNeeded
	Return BS
End Function

Function BSTR2W(ByVal BS As Const BSTR) As WString Ptr 'the caller is responsible for freeing the returned WString per DeAllocate
	Dim W As WString Ptr
	W = CAllocate(SysStringByteLen(BS) + 2)
	If BS Then memcpy W, BS, SysStringByteLen(BS)
	Return W
End Function
Function W2BSTR(ByVal W As Const WString Ptr) As BSTR 'the caller is responsible for freeing the returned BSTR per SysFreeString
	Return SysAllocString(W)
End Function

'well, this is the workhorse for all the Dispatch-Calls (IDispatch::Invoke)... there's easier Wrapper-Methods around this at the end of this module)
Dim Shared LastDispID As Long = 0, UseDispId As Long = 0
#ifdef __FB_64BIT__
	Function CallByName cdecl (vDisp As tagVARIANT, ByVal MethodName As LPOLESTR, ByVal CallFlag As WORD, TypeChars As String = "", ByVal Arg0 As Any Ptr = 0, ByVal Arg1 As Any Ptr = 0, ByVal Arg2 As Any Ptr = 0, ByVal Arg3 As Any Ptr = 0, ByVal Arg4 As Any Ptr = 0, ByVal Arg5 As Any Ptr = 0, ByVal Arg6 As Any Ptr = 0, ByVal Arg7 As Any Ptr = 0, ByVal Arg8 As Any Ptr = 0, ByVal Arg9 As Any Ptr = 0, ByVal Arg10 As Any Ptr = 0, ByVal Arg11 As Any Ptr = 0, ByVal Arg12 As Any Ptr = 0, ByVal Arg13 As Any Ptr = 0, ByVal Arg14 As Any Ptr = 0, ByVal Arg15 As Any Ptr = 0, ByVal Arg16 As Any Ptr = 0, ByVal Arg17 As Any Ptr = 0, ByVal Arg18 As Any Ptr = 0, ByVal Arg19 As Any Ptr = 0, ByVal Arg20 As Any Ptr = 0, ByVal Arg21 As Any Ptr = 0, ByVal Arg22 As Any Ptr = 0, ByVal Arg23 As Any Ptr = 0, ByVal Arg24 As Any Ptr = 0,ByVal Arg25 As Any Ptr = 0,ByVal Arg26 As Any Ptr = 0,ByVal Arg27 As Any Ptr = 0,ByVal Arg28 As Any Ptr = 0,ByVal Arg29 As Any Ptr = 0,ByVal Arg30 As Any Ptr = 0,ByVal Arg31 As Any Ptr = 0) As tagVARIANT
		Static DispParams As DISPPARAMS, DispidNamed As DISPID = DISPID_PROPERTYPUT
		Static VParams(31) As tagVARIANT, SArr(31) As BSTR, ArgsArr(31) As Any Ptr
		Const As UByte l=108,i=105,b=98,d=100,f=102,t=116,v=118,w=119,s=115,c=99,u=117,sR=83,wR=87 'to make the Type-Selects more readable
		Dim TypeChar As UByte, IsByRef As Boolean, VRes As tagVARIANT, DispId As DISPID
		Dim Args(31) As Any Ptr => {Arg0, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17, Arg18, Arg19, Arg20, Arg21, Arg22, Arg23, Arg24, Arg25, Arg26, Arg27, Arg28, Arg29, Arg30, Arg31}
		Dim k As Integer
		
		If UseDispId Then DispId = UseDispId: UseDispId = 0
		COMErr.Number = 0
		If DispId = 0 Then
			LastDispID = 0
			If HandleCOMErr(vDisp.pdispVal->lpVtbl->GetIDsOfNames(vDisp.pdispVal, @IID_NULL, @MethodName, 1, LOCALE_USER_DEFAULT, @DispId), MethodName) Then Return VRes
			LastDispID = DispId
		End If
		
		DispParams.cArgs = Len(TypeChars)
		DispParams.rgvarg = @VParams(0)
		DispParams.cNamedArgs = IIf(CallFlag >= DISPATCH_PROPERTYPUT, 1, 0)
		DispParams.rgdispidNamedArgs = IIf(CallFlag >= DISPATCH_PROPERTYPUT, @DispidNamed, 0)
		
		k = -1
		For j As Integer = DispParams.cArgs - 1 To 0 Step -1
			k = k + 1
			TypeChar = TypeChars[DispParams.cArgs - j - 1]
			IsByRef  = TypeChar < 97
			If IsByRef Then TypeChar += 32 'since the ByRef-Info is now retrieved, we work further with just the lower-case letter
			
			'in a first pass, we set only the proper Variant-Type-Members
			Select Case TypeChar
			Case s,w: VParams(j).vt = VT_BSTR    Or VT_BYREF
			Case u:   VParams(j).vt = VT_UI1     Or VT_BYREF
			Case i:   VParams(j).vt = VT_I2      Or VT_BYREF
			Case l:   VParams(j).vt = VT_I4      Or VT_BYREF
			Case c:   VParams(j).vt = VT_CY      Or IIf(IsByRef, VT_BYREF, 0)
			Case b:   VParams(j).vt = VT_BOOL    Or IIf(IsByRef, VT_BYREF, 0)
			Case f:   VParams(j).vt = VT_R4      Or IIf(IsByRef, VT_BYREF, 0)
			Case d:   VParams(j).vt = VT_R8      Or VT_BYREF
			Case t:   VParams(j).vt = VT_DATE    Or VT_BYREF
			Case v:   VParams(j).vt = VT_VARIANT Or VT_BYREF
			End Select
			
			'in a second pass, we set the Variant-Value-Members of our (static) VParams-Array
			Select Case TypeChar
			Case s,w:  If IsByRef Then ArgsArr(j) = Args(k)
				If SArr(j) Then SysFreeString SArr(j): SArr(j) = 0 'destroy the previous allocation from our static BSTR-Cache
				Select Case TypeChar
				Case s: If IsByRef Then SArr(j) = S2BSTR(*Cast(String Ptr, Args(k)))      Else SArr(j) = S2BSTR(*Cast(ZString Ptr, Args(k)))
				Case w: If IsByRef Then SArr(j) = W2BSTR(*Cast(WString Ptr Ptr, Args(k))) Else SArr(j) = W2BSTR(*Cast(WString Ptr, Args(k)))
				End Select
				VParams(j).pbstrVal = @SArr(j)
			Case v:    VParams(j) = *Cast(tagVARIANT Ptr, Args(k))
			Case f:    If IsByRef Then VParams(j).pbVal = Args(k) Else VParams(j).fltVal = CSng(*Cast(Double Ptr, Args(k)))
			Case b:    If IsByRef Then VParams(j).pbVal = Args(k) Else VParams(j).boolVal = CShort(*Cast(Boolean Ptr, Args(k)))
			Case c:    If IsByRef Then VParams(j).pbVal = Args(k) Else VParams(j).llVal = *Cast(LongInt Ptr, Args(k)) * 10000
			Case Else: If IsByRef Then VParams(j).pbVal = Args(k) Else VParams(j).pbVal  = Args(k)
			End Select
			
			'		'what remains is the type-based Args-Shift
			'		Select Case TypeChar
			'		Case s,w,v: Args = va_next(Args, Any Ptr)
			'		Case f,d,t: If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Double)
			'		Case i:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Short)
			'		Case l:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Long)
			'		Case b:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Boolean)
			'		Case u:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, UByte)
			'		Case c:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, LongInt)
			'		End Select
		Next
		
		HandleCOMErr vDisp.pdispVal->lpVtbl->Invoke(vDisp.pdispVal, DispId, @IID_NULL, LOCALE_USER_DEFAULT, CallFlag, @DispParams, @VRes, @EInfo, NULL), MethodName
		
		'this is needed, to pass back any StringValues from our SArr-BSTR-Cache into the FB-StringVariables (in the ByRef-case)
		For j As Integer = DispParams.cArgs - 1 To 0 Step -1
			If VParams(j).vt = (VT_BSTR Or VT_BYREF) Then
				Select Case TypeChars[DispParams.cArgs - j - 1]
				Case sR: *Cast(String Ptr, ArgsArr(j))      = BSTR2S(SArr(j)) 'pass back, in case it was a FB-ByRef-String
				Case wR: *Cast(WString Ptr Ptr, ArgsArr(j)) = BSTR2W(SArr(j)) 'pass back, in case it was a FB-ByRef-WString
				End Select
			End If
		Next
		
		Return VRes
	End Function
#else
	Function CallByName cdecl (vDisp As tagVARIANT, ByVal MethodName As LPOLESTR, ByVal CallFlag As WORD, TypeChars As String = "", ByVal Args As Any Ptr) As tagVARIANT
		Static DispParams As DISPPARAMS, DispidNamed As DISPID = DISPID_PROPERTYPUT
		Static VParams(31) As tagVARIANT, SArr(31) As BSTR, ArgsArr(31) As Any Ptr
		Const As UByte l=108,i=105,b=98,d=100,f=102,t=116,v=118,w=119,s=115,c=99,u=117,sR=83,wR=87 'to make the Type-Selects more readable
		Dim TypeChar As UByte, IsByRef As Boolean, VRes As tagVARIANT, DispId As DISPID
		
		If UseDispId Then DispId = UseDispId: UseDispId = 0
		COMErr.Number = 0
		If DispId = 0 Then
			LastDispID = 0
			If HandleCOMErr(vDisp.pdispVal->lpVtbl->GetIDsOfNames(vDisp.pdispVal, @IID_NULL, @MethodName, 1, LOCALE_USER_DEFAULT, @DispId), MethodName) Then Return VRes
			LastDispID = DispId
		End If
		
		DispParams.cArgs = Len(TypeChars)
		DispParams.rgvarg = @VParams(0)
		DispParams.cNamedArgs = IIf(CallFlag >= DISPATCH_PROPERTYPUT, 1, 0)
		DispParams.rgdispidNamedArgs = IIf(CallFlag >= DISPATCH_PROPERTYPUT, @DispidNamed, 0)
		
		For j As Integer = DispParams.cArgs - 1 To 0 Step -1
			TypeChar = TypeChars[DispParams.cArgs - j - 1]
			IsByRef  = TypeChar < 97
			If IsByRef Then TypeChar += 32 'since the ByRef-Info is now retrieved, we work further with just the lower-case letter
			
			'in a first pass, we set only the proper Variant-Type-Members
			Select Case TypeChar
			Case s,w: VParams(j).vt = VT_BSTR    Or VT_BYREF
			Case u:   VParams(j).vt = VT_UI1     Or VT_BYREF
			Case i:   VParams(j).vt = VT_I2      Or VT_BYREF
			Case l:   VParams(j).vt = VT_I4      Or VT_BYREF
			Case c:   VParams(j).vt = VT_CY      Or IIf(IsByRef, VT_BYREF, 0)
			Case b:   VParams(j).vt = VT_BOOL    Or IIf(IsByRef, VT_BYREF, 0)
			Case f:   VParams(j).vt = VT_R4      Or IIf(IsByRef, VT_BYREF, 0)
			Case d:   VParams(j).vt = VT_R8      Or VT_BYREF
			Case t:   VParams(j).vt = VT_DATE    Or VT_BYREF
			Case v:   VParams(j).vt = VT_VARIANT Or VT_BYREF
			End Select
			
			'in a second pass, we set the Variant-Value-Members of our (static) VParams-Array
			Select Case TypeChar
			Case s,w:  If IsByRef Then ArgsArr(j) = Args
				If SArr(j) Then SysFreeString SArr(j): SArr(j) = 0 'destroy the previous allocation from our static BSTR-Cache
				Select Case TypeChar
				Case s: If IsByRef Then SArr(j) = S2BSTR(*va_arg(Args, String Ptr))      Else SArr(j) = S2BSTR(*va_arg(Args, ZString Ptr))
				Case w: If IsByRef Then SArr(j) = W2BSTR(*va_arg(Args, WString Ptr Ptr)) Else SArr(j) = W2BSTR(*va_arg(Args, WString Ptr))
				End Select
				VParams(j).pbstrVal = @SArr(j)
			Case v:    VParams(j) = *va_arg(Args, tagVARIANT Ptr)
			Case f:    If IsByRef Then VParams(j).pbVal = va_arg(Args, Any Ptr) Else VParams(j).fltVal = CSng(va_arg(Args, Double))
			Case b:    If IsByRef Then VParams(j).pbVal = va_arg(Args, Any Ptr) Else VParams(j).boolVal = CShort(va_arg(Args, Boolean))
			Case c:    If IsByRef Then VParams(j).pbVal = va_arg(Args, Any Ptr) Else VParams(j).llVal = va_arg(Args, LongInt) * 10000
			Case Else: If IsByRef Then VParams(j).pbVal = va_arg(Args, Any Ptr) Else VParams(j).pbVal  = Args
			End Select
			
			'what remains is the type-based Args-Shift
			Select Case TypeChar
			Case s,w,v: Args = va_next(Args, Any Ptr)
			Case f,d,t: If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Double)
			Case i:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Short)
			Case l:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Long)
			Case b:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, Boolean)
			Case u:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, UByte)
			Case c:     If IsByRef Then Args = va_next(Args, Any Ptr) Else Args = va_next(Args, LongInt)
			End Select
		Next
		
		HandleCOMErr vDisp.pdispVal->lpVtbl->Invoke(vDisp.pdispVal, DispId, @IID_NULL, LOCALE_USER_DEFAULT, CallFlag, @DispParams, @VRes, @EInfo, NULL), MethodName
		
		'this is needed, to pass back any StringValues from our SArr-BSTR-Cache into the FB-StringVariables (in the ByRef-case)
		For j As Integer = DispParams.cArgs - 1 To 0 Step -1
			If VParams(j).vt = (VT_BSTR Or VT_BYREF) Then
				Select Case TypeChars[DispParams.cArgs - j - 1]
				Case sR: *va_arg(ArgsArr(j), String Ptr)      = BSTR2S(SArr(j)) 'pass back, in case it was a FB-ByRef-String
				Case wR: *va_arg(ArgsArr(j), WString Ptr Ptr) = BSTR2W(SArr(j)) 'pass back, in case it was a FB-ByRef-WString
				End Select
			End If
		Next
		
		Return VRes
	End Function
#endif

Function WCacheValue(BSTR2Copy As BSTR) As WString Ptr 'a little Helper, to avoid leaking with the WString-DataType (in the User-Code)
	Const  CacheSize As Integer = 1024
	Static Cache(0 To CacheSize-1) As WString Ptr, NxtIdx As Integer
	NxtIdx= (NxtIdx + 1) Mod CacheSize
	If Cache(NxtIdx) Then Deallocate Cache(NxtIdx)
	Cache(NxtIdx) = BSTR2W(BSTR2Copy)
	Return Cache(NxtIdx)
End Function

'*************************** Begin of the Variant-Wrapper-Section *******************************

Enum vbVarType
	vbEmpty    = &H0000
	vbNull     = &H0001
	vbInteger  = &H0002
	vbLong     = &H0003
	vbSingle   = &H0004
	vbDouble   = &H0005
	vbCurrency = &H0006
	vbDate     = &H0007
	vbString   = &H0008
	vbObject   = &H0009
	vbError    = &H000A
	vbBoolean  = &H000B
	vbVariant  = &H000C
	vbDecimal  = &H000E
	vbByte     = &H0011
	vbArray    = &H2000
	vbByRef    = &H4000
End Enum
#define Set
#define Nothing 0
'One of the MFF mark
#ifndef APP_TITLE
	'finally a MsgBox-OverLoad, which accepts a Object_Com_ as the Msg-Parameter
	Function MsgBox cdecl (ByVal MSG As Object_Com_, ByVal Flags As Long = MB_ICONINFORMATION) As Long
		If MSG.V.vt = vbString Then
			Return MessageBoxW(GetActiveWindow, MSG.V.bstrVal, AppName, Flags)
		Else
			Dim VV As tagVARIANT
			HandleCOMErr VariantChangeTypeEx(@VV, @MSG.V, DefaultLocale_VariantConv, VARIANT_NOVALUEPROP Or VARIANT_ALPHABOOL, vbString), "SimpleVariant.MsgBox"
			Function = MessageBoxW(GetActiveWindow, VV.bstrVal, AppName, Flags)
			VariantClear @VV
		End If
	End Function
#endif
