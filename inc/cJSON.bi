'   Copyright (c) 2009-2017 Dave Gamble and cJSON contributors

'   Permission is hereby granted, free of charge, to any person obtaining a copy
'   of this software and associated documentation files (the "Software"), to deal
'   in the Software without restriction, including without limitation the rights
'   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
'   copies of the Software, and to permit persons to whom the Software is
'   furnished to do so, subject to the following conditions:

'   The above copyright notice and this permission notice shall be included in
'   all copies or substantial portions of the Software.

'   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
'   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
'   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
'   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
'   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
'   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
'   THE SOFTWARE.

#pragma once

#include once "crt/stddef.bi"

#ifdef __FB_WIN32__
	Extern "Windows"
#else
	Extern "C"
#endif

#define cJSON__h
#inclib "cjson"

#ifdef __FB_WIN32__
	#define __WINDOWS__
	#define CJSON_CDECL __cdecl
	#define CJSON_STDCALL __stdcall
	#define CJSON_EXPORT_SYMBOLS
	'' TODO: #define CJSON_PUBLIC(type) __declspec(dllexport) type CJSON_STDCALL
#else
	#define CJSON_CDECL
	#define CJSON_STDCALL
	#define CJSON_PUBLIC(type) type
#endif

Const CJSON_VERSION_MAJOR = 1
Const CJSON_VERSION_MINOR = 7
Const CJSON_VERSION_PATCH = 15
Const cJSON_Invalid = 0
Const cJSON_False = 1 Shl 0
Const cJSON_True = 1 Shl 1
Const cJSON_NULL = 1 Shl 2
Const cJSON_Number = 1 Shl 3
Const cJSON_String = 1 Shl 4
Const cJSON_Array = 1 Shl 5
Const cJSON_Object = 1 Shl 6
Const cJSON_Raw = 1 Shl 7
Const cJSON_IsReference = 256
Const cJSON_StringIsConst = 512

Type cJSON
	next As cJSON Ptr
	prev As cJSON Ptr
	child As cJSON Ptr
	As Long type
	valuestring As ZString Ptr
	valueint As Long
	valuedouble As Double
	string As ZString Ptr
End type

Type cJSON_Hooks
	malloc_fn As Function cdecl(ByVal sz As UInteger) As Any Ptr
	free_fn As Sub cdecl(ByVal Ptr As Any Ptr)
End Type

Type cJSON_bool As Boolean
Const CJSON_NESTING_LIMIT = 1000
Declare Function cJSON_Version() As Const ZString Ptr
Declare Sub cJSON_InitHooks(ByVal hooks As cJSON_Hooks Ptr)
Declare Function cJSON_Parse(ByVal value As Const ZString Ptr) As cJSON Ptr
Declare Function cJSON_ParseWithLength(ByVal value As Const ZString Ptr, ByVal buffer_length As UInteger) As cJSON Ptr
Declare Function cJSON_ParseWithOpts(ByVal value As Const ZString Ptr, ByVal return_parse_end As Const ZString Ptr Ptr, ByVal require_null_terminated As cJSON_bool) As cJSON Ptr
Declare Function cJSON_ParseWithLengthOpts(ByVal value As Const ZString Ptr, ByVal buffer_length As UInteger, ByVal return_parse_end As Const ZString Ptr Ptr, ByVal require_null_terminated As cJSON_bool) As cJSON Ptr
Declare Function cJSON_Print(ByVal item As Const cJSON Ptr) As ZString Ptr
Declare Function cJSON_PrintUnformatted(ByVal item As Const cJSON Ptr) As ZString Ptr
Declare Function cJSON_PrintBuffered(ByVal item As Const cJSON Ptr, ByVal prebuffer As Long, ByVal fmt As cJSON_bool) As ZString Ptr
Declare Function cJSON_PrintPreallocated(ByVal item As cJSON Ptr, ByVal buffer As ZString Ptr, ByVal length As Const Long, ByVal format As Const cJSON_bool) As cJSON_bool
Declare Sub cJSON_Delete(ByVal item As cJSON Ptr)
Declare Function cJSON_GetArraySize(ByVal array As Const cJSON Ptr) As Long
Declare Function cJSON_GetArrayItem(ByVal array As Const cJSON Ptr, ByVal index As Long) As cJSON Ptr
Declare Function cJSON_GetObjectItem(ByVal object As Const cJSON Const Ptr, ByVal string As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_GetObjectItemCaseSensitive(ByVal object As Const cJSON Const Ptr, ByVal string As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_HasObjectItem(ByVal object As Const cJSON Ptr, ByVal string As Const ZString Ptr) As cJSON_bool
Declare Function cJSON_GetErrorPtr() As Const ZString Ptr
Declare Function cJSON_GetStringValue(ByVal item As Const cJSON Const Ptr) As ZString Ptr
Declare Function cJSON_GetNumberValue(ByVal item As Const cJSON Const Ptr) As Double
Declare Function cJSON_IsInvalid(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsFalse(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsTrue(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsBool(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsNull(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsNumber(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsString(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsArray(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsObject(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_IsRaw(ByVal item As Const cJSON Const Ptr) As cJSON_bool
Declare Function cJSON_CreateNull() As cJSON Ptr
Declare Function cJSON_CreateTrue() As cJSON Ptr
Declare Function cJSON_CreateFalse() As cJSON Ptr
Declare Function cJSON_CreateBool(ByVal boolean As cJSON_bool) As cJSON Ptr
Declare Function cJSON_CreateNumber(ByVal num As Double) As cJSON Ptr
Declare Function cJSON_CreateString(ByVal string As Const ZString Ptr) As cJSON Ptr
Declare Function cJSON_CreateRaw(ByVal raw As Const ZString Ptr) As cJSON Ptr
Declare Function cJSON_CreateArray() As cJSON Ptr
Declare Function cJSON_CreateObject() As cJSON Ptr
Declare Function cJSON_CreateStringReference(ByVal string As Const ZString Ptr) As cJSON Ptr
Declare Function cJSON_CreateObjectReference(ByVal child As Const cJSON Ptr) As cJSON Ptr
Declare Function cJSON_CreateArrayReference(ByVal child As Const cJSON Ptr) As cJSON Ptr
Declare Function cJSON_CreateIntArray(ByVal numbers As Const Long Ptr, ByVal count As Long) As cJSON Ptr
Declare Function cJSON_CreateFloatArray(ByVal numbers As Const Single Ptr, ByVal count As Long) As cJSON Ptr
Declare Function cJSON_CreateDoubleArray(ByVal numbers As Const Double Ptr, ByVal count As Long) As cJSON Ptr
Declare Function cJSON_CreateStringArray(ByVal strings As Const ZString Const Ptr Ptr, ByVal count As Long) As cJSON Ptr
Declare Function cJSON_AddItemToArray(ByVal array As cJSON Ptr, ByVal item As cJSON Ptr) As cJSON_bool
Declare Function cJSON_AddItemToObject(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr, ByVal item As cJSON Ptr) As cJSON_bool
Declare Function cJSON_AddItemToObjectCS(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr, ByVal item As cJSON Ptr) As cJSON_bool
Declare Function cJSON_AddItemReferenceToArray(ByVal array As cJSON Ptr, ByVal item As cJSON Ptr) As cJSON_bool
Declare Function cJSON_AddItemReferenceToObject(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr, ByVal item As cJSON Ptr) As cJSON_bool
Declare Function cJSON_DetachItemViaPointer(ByVal parent As cJSON Ptr, ByVal item As cJSON Const Ptr) As cJSON Ptr
Declare Function cJSON_DetachItemFromArray(ByVal array As cJSON Ptr, ByVal which As Long) As cJSON Ptr
Declare Sub cJSON_DeleteItemFromArray(ByVal array As cJSON Ptr, ByVal which As Long)
Declare Function cJSON_DetachItemFromObject(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr) As cJSON Ptr
Declare Function cJSON_DetachItemFromObjectCaseSensitive(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr) As cJSON Ptr
Declare Sub cJSON_DeleteItemFromObject(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr)
Declare Sub cJSON_DeleteItemFromObjectCaseSensitive(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr)
Declare Function cJSON_InsertItemInArray(ByVal array As cJSON Ptr, ByVal which As Long, ByVal newitem As cJSON Ptr) As cJSON_bool
Declare Function cJSON_ReplaceItemViaPointer(ByVal parent As cJSON Const Ptr, ByVal item As cJSON Const Ptr, ByVal replacement As cJSON Ptr) As cJSON_bool
Declare Function cJSON_ReplaceItemInArray(ByVal array As cJSON Ptr, ByVal which As Long, ByVal newitem As cJSON Ptr) As cJSON_bool
Declare Function cJSON_ReplaceItemInObject(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr, ByVal newitem As cJSON Ptr) As cJSON_bool
Declare Function cJSON_ReplaceItemInObjectCaseSensitive(ByVal object As cJSON Ptr, ByVal string As Const ZString Ptr, ByVal newitem As cJSON Ptr) As cJSON_bool
Declare Function cJSON_Duplicate(ByVal item As Const cJSON Ptr, ByVal recurse As cJSON_bool) As cJSON Ptr
Declare Function cJSON_Compare(ByVal a As Const cJSON Const Ptr, ByVal b As Const cJSON Const Ptr, ByVal case_sensitive As Const cJSON_bool) As cJSON_bool
Declare Sub cJSON_Minify(ByVal json As ZString Ptr)
Declare Function cJSON_AddNullToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddTrueToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddFalseToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddBoolToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr, ByVal boolean As Const cJSON_bool) As cJSON Ptr
Declare Function cJSON_AddNumberToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr, ByVal number As Const Double) As cJSON Ptr
Declare Function cJSON_AddStringToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr, ByVal string As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddRawToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr, ByVal raw As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddObjectToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr) As cJSON Ptr
Declare Function cJSON_AddArrayToObject(ByVal object As cJSON Const Ptr, ByVal name As Const ZString Const Ptr) As cJSON Ptr
'' TODO: #define cJSON_SetIntValue(object, number) ((object) ? (object)->valueint = (object)->valuedouble = (number) : (number))
Declare Function cJSON_SetNumberHelper(ByVal object As cJSON Ptr, ByVal number As Double) As Double
#define cJSON_SetNumberValue(object, number) IIf(object <> NULL, cJSON_SetNumberHelper(object, CDbl(number)), (number))
Declare Function cJSON_SetValuestring(ByVal object As cJSON Ptr, ByVal valuestring As Const ZString Ptr) As ZString Ptr
'' TODO: #define cJSON_SetBoolValue(object, boolValue) ( (object != NULL && ((object)->type & (cJSON_False|cJSON_True))) ? (object)->type=((object)->type &(~(cJSON_False|cJSON_True)))|((boolValue)?cJSON_True:cJSON_False) : cJSON_Invalid )
'' TODO: #define cJSON_ArrayForEach(element, array) for(element = (array != NULL) ? (array)->child : NULL; element != NULL; element = element->next)
Declare Function cJSON_malloc(ByVal size As UInteger) As Any Ptr
Declare Sub cJSON_free(ByVal object As Any Ptr)

End Extern


