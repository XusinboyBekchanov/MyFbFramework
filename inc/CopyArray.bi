'################################################################################
'#  CopyArray.bi                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Based on: the code posted by fxm on the freeBasic forum                     #
'#  See also：                                                                  #
'#   https://www.freebasic.net/forum/viewtopic.php?p=296320#p296320             #
'#                                                                              #
'################################################################################

#macro ArrayDefine(DataType)
	#include once "fbc-int/array.bi"
	#ifndef existUDT##DataType
		#define existUDT##DataType
		Namespace FXM
			Type UDT##DataType
				Dim As DataType Array(Any, Any, Any, Any, Any, Any, Any, Any)
			End Type
		End Namespace
	#endif
#endmacro
Type AnyPtr As Any Ptr
Type WStringPtr As WString Ptr
Type ZStringPtr As ZString Ptr
ArrayDefine(Double)
ArrayDefine(Long)
ArrayDefine(Single)
ArrayDefine(Integer)
ArrayDefine(String)
ArrayDefine(AnyPtr)
ArrayDefine(ZStringPtr)
ArrayDefine(WStringPtr)

#macro CopyArray(Dst, Src, DataType)
	Scope
		Dim As FXM.UDT##DataType Ptr Ps = CPtr(FXM.UDT##DataType Ptr, FBC.ArrayDescriptorPtr(Src()))
		Dim As FXM.UDT##DataType Ptr Pd = CPtr(FXM.UDT##DataType Ptr, FBC.ArrayDescriptorPtr(Dst()))
		*Pd = *Ps
	End Scope
#endmacro

