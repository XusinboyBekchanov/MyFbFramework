@echo "build FBSound 1.2 for Windows x86_64:"
@REM Set the right path to your 64-bit FreeBASIC compiler !
c:\GitHub\VisualFBEditorPro\compiler\fbc640.exe -w pedantic -mt -gen gcc -asm intel -lib src/fbscpu.bas -x ./lib/win64/libfbscpu.a
c:\GitHub\VisualFBEditorPro\compiler\fbc640.exe -w pedantic -mt -gen gcc -asm intel -lib src/fbsdsp.bas -x ./lib/win64/libfbsdsp.a
c:\GitHub\VisualFBEditorPro\compiler\fbc640.exe -w pedantic -mt -gen gcc -asm intel -p ./lib/win64 -dll src/fbsound.bas -x ./lib/win64/fbsound.dll
c:\GitHub\VisualFBEditorPro\compiler\fbc640.exe -w pedantic -mt -gen gcc -asm intel -dll src/plug-ds.bas -x ./lib/win64/fbsound-ds.dll
c:\GitHub\VisualFBEditorPro\compiler\fbc640.exe -w pedantic -mt -gen gcc -asm intel -dll src/plug-mm.bas -x ./lib/win64/fbsound-mm.dll
REM del ..\fbsound-1.2\tests\libfbsound-64.dll.a
REM del ..\fbsound-1.2\tests\libfbsound-ds-64.dll.a
REM del ..\fbsound-1.2\tests\libfbsound-mm-64.dll.a
@echo "ready!"
@pause

