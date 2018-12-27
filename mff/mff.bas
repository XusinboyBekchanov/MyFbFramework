#IfDef __FB_Win32__
	#IfDef __FB_64bit__
	    '#Compile -dll -x "mff64.dll" "mff.rc"
	#Else
	    '#Compile -dll -x "mff32.dll" "mff.rc"
	#EndIf
#Else
	#IfDef __FB_64bit__
	    '#Compile -dll -x "libmff64.so"
	#Else
	    '#Compile -dll -x "libmff32.so"
	#EndIf
#EndIf
#Include Once "mff.bi"
