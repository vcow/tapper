@echo off
set out-assets-path=.\..\..\build\assets
set out-sound-path=.\..\..\build\sound
set out-icon-path=.\..\..\build\icon

if exist %out-assets-path% rmdir /s /q %out-assets-path%
mkdir %out-assets-path%

if exist %out-sound-path% rmdir /s /q %out-sound-path%
mkdir %out-sound-path%

if exist %out-icon-path% rmdir /s /q %out-icon-path%
mkdir %out-icon-path%

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

for /d %%X in (%out-icon-path%) do (
    set out-path=%%~fX
    pushd icons
    for /r %%I in (*.png) do (
        copy /y %%~fI !out-path! > nul
    )
    popd
)

set out-path=
set out-assets-path=
set out-sound-path=
set out-icon-path=
@echo on
