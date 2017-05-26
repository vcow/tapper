@echo off
set out-path=..\..\..\..\build\assets

if exist %out-path% rmdir /s /q %out-path%
mkdir %out-path%

for /r %%I in (*.xml,*.atf,*.fnt) do (
	copy /y %%~fI %out-path% > nul
)

set out-path=
@echo on
