@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: seq2prores.bat - Image Sequence to ProRes Converter
:: ============================================================================
:: Description: Converts image sequences to ProRes video files using FFmpeg
:: Usage: Drag and drop the first image of a sequence onto this script
:: ============================================================================

echo.
echo ========================================
echo   Image Sequence to ProRes Converter
echo ========================================
echo.

:: Check if a file was dropped
if "%~1"=="" (
    echo ERROR: No file was dropped onto the script.
    echo Please drag and drop the first image of your sequence onto this script.
    pause
    exit /b 1
)

:: Store the dropped file path
set "DROPPED_FILE=%~1"
echo Dropped file: "%DROPPED_FILE%"

:: Check if the file exists
if not exist "%DROPPED_FILE%" (
    echo ERROR: The file does not exist: "%DROPPED_FILE%"
    pause
    exit /b 1
)

:: Set working directory to the folder containing the dropped file
set "WORK_DIR=%~dp1"
cd /d "%WORK_DIR%"
echo Working directory: "%WORK_DIR%"
echo.

:: Verify FFmpeg is accessible
where ffmpeg.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: ffmpeg.exe is not found in the system PATH.
    echo Please install FFmpeg and add it to your PATH environment variable.
    echo Download FFmpeg from: https://ffmpeg.org/download.html
    pause
    exit /b 1
)
echo FFmpeg found: OK
echo.

:: Extract filename components
set "FULL_FILENAME=%~nx1"
set "BASE_NAME="
set "PADDING="
set "EXTENSION=%~x1"

:: Remove the extension to get the name with padding
set "NAME_WITH_PADDING=%~n1"

:: Parse the filename to extract base name and padding
:: The filename format is: {name}.{padding}.{extension}
:: Example: shot_01.0001.exr -> base=shot_01, padding=0001

:: Find the last dot in the name (before extension)
set "TEMP_NAME=%NAME_WITH_PADDING%"
set "LAST_PART="

:LOOP_PARSE
for /f "tokens=1* delims=." %%a in ("%TEMP_NAME%") do (
    if "%%b"=="" (
        set "LAST_PART=%%a"
        goto END_LOOP
    ) else (
        if defined BASE_NAME (
            set "BASE_NAME=!BASE_NAME!.%%a"
        ) else (
            set "BASE_NAME=%%a"
        )
        set "TEMP_NAME=%%b"
        goto LOOP_PARSE
    )
)
:END_LOOP

:: The last part should be the padding
set "PADDING=%LAST_PART%"

:: Validate padding (should be all digits)
if not defined PADDING (
    echo ERROR: Unable to parse padding from filename.
    echo Expected format: {name}.{padding}.{extension}
    echo Example: shot_01.0001.exr
    echo Received: "%FULL_FILENAME%"
    pause
    exit /b 1
)

echo %PADDING%| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo ERROR: Unable to parse padding from filename.
    echo Expected format: {name}.{padding}.{extension}
    echo Example: shot_01.0001.exr
    echo Received: "%FULL_FILENAME%"
    pause
    exit /b 1
)

:: Calculate padding length
set "PADDING_LENGTH=0"
set "TEMP_PADDING=%PADDING%"
:COUNT_LOOP
if defined TEMP_PADDING (
    set "TEMP_PADDING=%TEMP_PADDING:~1%"
    set /a PADDING_LENGTH+=1
    goto COUNT_LOOP
)

echo Parsed components:
echo   Base name: %BASE_NAME%
echo   Padding: %PADDING% (length: %PADDING_LENGTH%)
echo   Extension: %EXTENSION%
echo.

:: Construct FFmpeg input pattern
:: Example: shot_01.%%04d.exr
set "INPUT_PATTERN=%BASE_NAME%.%%0%PADDING_LENGTH%d%EXTENSION%"
echo FFmpeg input pattern: "%INPUT_PATTERN%"

:: Construct output filename
set "OUTPUT_FILE=%BASE_NAME%.mov"
echo Output file: "%OUTPUT_FILE%"
echo.

:: Setup log file
set "LOG_FILE=%WORK_DIR%conversion_log.txt"

:: Execute FFmpeg conversion
echo Starting FFmpeg conversion...
echo ----------------------------------------
echo Command details:
echo   Frame rate: 24 FPS
echo   Codec: ProRes Proxy (profile:v 0)
echo   Color space: BT.709
echo ----------------------------------------
echo.

ffmpeg -framerate 24 -i "%INPUT_PATTERN%" -c:v prores -profile:v 0 -color_trc bt709 -color_primaries bt709 -colorspace bt709 -y "%OUTPUT_FILE%" > "%LOG_FILE%" 2>&1

:: Check FFmpeg exit code
if errorlevel 1 (
    echo.
    echo ========================================
    echo   ERROR: Conversion failed
    echo ========================================
    echo.
    echo The FFmpeg process encountered an error.
    echo Log file preserved at: "%LOG_FILE%"
    echo.
    echo Please check the log file for details.
    pause
    exit /b 1
) else (
    echo.
    echo ========================================
    echo   SUCCESS: Conversion completed
    echo ========================================
    echo.
    echo Output file: "%OUTPUT_FILE%"
    echo.
    
    :: Delete log file on success
    if exist "%LOG_FILE%" (
        del "%LOG_FILE%"
        echo Log file deleted (conversion successful).
    )
    echo.
    pause
    exit /b 0
)
