#IfDef __FB_64bit__
    '#Compile -dll -x "mff64.dll" "mff.rc"
#Else
    '#Compile -g -dll -x "mff32.dll" "mff.rc"
#EndIf
'#Compile -dll -x "libmff64.so"
#Include Once "mff.bi"
