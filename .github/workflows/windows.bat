cd ..
cd ..
cd ..

curl -L -O https://www.7-zip.org/a/7za920.zip

PowerShell Expand-Archive -LiteralPath "7za920.zip" -DestinationPath ".\7z" -Force

curl -L -O https://sourceforge.net/projects/fbc/files/FreeBASIC-1.10.0/Binaries-Windows/FreeBASIC-1.10.0-winlibs-gcc-9.3.0.7z

7z\7za.exe x "FreeBASIC-1.10.0-winlibs-gcc-9.3.0.7z"

cd MyFbFramework\mff

..\..\FreeBASIC-1.10.0-winlibs-gcc-9.3.0\fbc32.exe -b "mff.bi" "mff.rc" -dll -x "../mff32.dll" -v

if not exist ../mff32.dll exit 1

cd ..
ls
