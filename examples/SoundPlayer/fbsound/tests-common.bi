#pragma once

Const TESTS_DATA_PATH = "../data/"

#if Not defined( FBSOUND_USE_DYNAMIC ) And Not defined( FBSOUND_USE_STATIC )
	'#define FBSOUND_USE_DYNAMIC
	'#define FBSOUND_USE_STATIC
#endif

'' set the DLL path before including fbsound_dynamic.bi to override
#if defined( FBSOUND_USE_DYNAMIC )
	#ifdef __FB_WIN32__
		#ifdef __FB_64BIT__
			Const FBSOUND_DLL_PATH = "../bin/win64/"
		#else
			Const FBSOUND_DLL_PATH  = "../bin/win32/"
		#endif
	#else
		Const FBSOUND_DLL_PATH  = ""
	#endif
#else
	Const FBSOUND_DLL_PATH  = ""
#endif

#if defined( FBSOUND_USE_DYNAMIC )
	#include "mff/fbsound/fbsound_dynamic.bi"
	#include "mff/fbsound/fbsound.bi"
#else
	#define FBSOUND_USE_STATIC
	#include once "mff/fbsound/fbsound.bi"
	#include once "mff/fbsound/plug.bi"
	#include once "mff/fbsound/plug-static.bi"
	#include once "mff/fbsound/fbsound.bas"
	#include once "mff/fbsound/plug-ds.bas"
	#include once "mff/fbsound/plug-mm.bas"
	#include once "mff/fbsound/plug-static.bas"
	
#endif

