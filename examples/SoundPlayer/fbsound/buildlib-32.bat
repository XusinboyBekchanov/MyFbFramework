@echo "build FBSound 1.2 for Windows x86:"
@REM Set the right path to your 32-bit FreeBASIC compiler !
c:\GitHub\VisualFBEditorPro\compiler\fbc320.exe -w pedantic  -mt -gen gcc -asm intel -lib src/fbscpu.bas -x lib/win32/libfbscpu.a
c:\GitHub\VisualFBEditorPro\compiler\fbc320.exe -w pedantic  -mt -gen gcc -asm intel -lib src/fbsdsp.bas -x lib/win32/libfbsdsp.a
c:\GitHub\VisualFBEditorPro\compiler\fbc320.exe -w pedantic  -mt -gen gcc -asm intel -p lib/win32 -dll src/fbsound.bas -x lib/win32/fbsound.dll
c:\GitHub\VisualFBEditorPro\compiler\fbc320.exe -w pedantic  -mt -gen gcc -asm intel -dll src/plug-ds.bas -x lib/win32/fbsound-ds.dll
c:\GitHub\VisualFBEditorPro\compiler\fbc320.exe -w pedantic  -mt -gen gcc -asm intel -dll src/plug-mm.bas -x lib/win32/fbsound-mm.dll
REM del ..\fbsound-1.2\tests\libfbsound-32.dll.a
REM del ..\fbsound-1.2\tests\libfbsound-ds-32.dll.a
REM del ..\fbsound-1.2\tests\libfbsound-mm-32.dll.a
@echo "ready!"
@pause

