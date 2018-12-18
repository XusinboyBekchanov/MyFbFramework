'#Compile -dll -x "libmff64.so"

#IfDef __FB_64bit__

    '#Compile -dll -x "mff64.dll" "mff.rc"

#Else

    '#Compile -dll -x "mff32.dll" "mff.rc"

#EndIf


#Include Once "mff.bi"
