@ECHO off

rem public variables, change as you need
set REPO_DIR="E:\windows-chewing-tsf"

set CMAKE="C:\cmake\bin\cmake.exe"
set "CMAKE_GEN_X86=Visual Studio 12 2013"
set "CMAKE_GEN_X64=%CMAKE_GEN_X86% Win64"

set SOL_FILE="windows-chewing-tsf.sln"
set MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"
set "MSBUILD_CMD=/m /p:Configuration=Release /t:Clean;Build"

set NSIS="C:\Program Files (x86)\NSIS\Bin\makensis.exe"

rem private variables
set BUILD_DIR="chewing_build"


rem prepare & build
mkdir %BUILD_DIR% && cd %BUILD_DIR%
	rem compile x86
	mkdir "x86" && cd "x86"
	%CMAKE% -G "%CMAKE_GEN_X86%" %REPO_DIR%
	%MSBUILD% %SOL_FILE% %MSBUILD_CMD%
	cd ..

	rem compile x64
	mkdir "x64" && cd "x64"
	%CMAKE% -G "%CMAKE_GEN_X64%" %REPO_DIR%
	%MSBUILD% %SOL_FILE% %MSBUILD_CMD%
	cd ..

	rem NSIS
	mkdir "nsis" && cd "nsis"
		copy "%REPO_DIR%\installer\*" "."
		copy "%REPO_DIR%\COPYING.txt" "."

		mkdir "Dictionary"
		copy "..\x86\libchewing\data\*" ".\Dictionary"

		mkdir "x86"
		copy "..\x86\ChewingTextService\Release\*.dll" ".\x86"
		copy "..\x86\ChewingPreferences\Release\*.exe" "."

		mkdir "x64"
		copy "..\x64\ChewingTextService\Release\*.dll" ".\x64"

		%NSIS% "installer.nsi"
	cd ..
cd ..

rem get installer
copy "%BUILD_DIR%\nsis\windows-chewing-tsf.exe" "."

rem cleanup
rem rmdir /S /Q %BUILD_DIR%
