@echo off
set out-assets-path=.\..\..\build\assets
set out-sound-path=.\..\..\build\sound

if exist %out-assets-path% rmdir /s /q %out-assets-path%
mkdir %out-assets-path%

if exist %out-sound-path% rmdir /s /q %out-sound-path%
mkdir %out-sound-path%

setlocal EnableDelayedExpansion
for /d %%X in (%out-assets-path%) do (
    set out-path=%%~fX
    pushd graphics\assets
    for /r %%I in (*.xml,*.atf,*.fnt) do (
        copy /y %%~fI !out-path! > nul
    )
    popd
)

for /d %%X in (%out-sound-path%) do (
    set out-path=%%~fX
    pushd sound
    for /r %%I in (*.mp3) do (
        copy /y %%~fI !out-path! > nul
    )
    popd
)

set out-path=
set out-assets-path=
set out-sound-path=
@echo on
