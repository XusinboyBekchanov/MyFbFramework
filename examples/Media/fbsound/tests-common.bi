#pragma once

Const TESTS_DATA_PATH = "../../Resources/"

#if Not defined( FBSOUND_USE_DYNAMIC ) And Not defined( FBSOUND_USE_STATIC ) 
'#define FBSOUND_USE_DYNAMIC
#define FBSOUND_USE_STATIC
#endif

'' set the DLL path before including fbsound_dynamic.bi to override
#if defined( FBSOUND_USE_DYNAMIC )
	#ifdef __FB_WIN32__
		#ifdef __FB_64BIT__
			'Const FBSOUND_DLL_PATH = "../../../lib/win-x64/"
		#else
			'Const FBSOUND_DLL_PATH  = "../../../lib/win-x86/"
		#endif
	#else
		Const FBSOUND_DLL_PATH  = ""
	#endif
#else
	Const FBSOUND_DLL_PATH  = ""
#endif

#if defined( FBSOUND_USE_DYNAMIC )
#include "inc/fbsound/fbsound_dynamic.bi"
#endif

#if defined( FBSOUND_USE_STATIC )
'
'#ifdef __FB_WIN32__
' #ifndef __FB_64BIT__
'  #libpath "./lib/win32/"
' #else
'  #libpath "./lib/win64/"
' #endif 
'#else
' #ifdef  __FB_LINUX__
'   #ifndef __FB_64BIT__
'    #libpath "./lib/lin32/"
'   #else
'    #libpath "./lib/lin64/"
'   #endif
' #else
'   #error 666: Build target must be Windows or Linux !
' #endif
'#endif

#include "inc/fbsound/fbsound.bi"

#endif  
