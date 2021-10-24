@echo off
mode con cols=150 lines=50
set /p pass=Password: 
set cdnow=%cd%
set decrypt_path=%cdnow%\testumgebung
set b=0
if exist "%cdnow%\decrypt_me.txt" del "%cdnow%\decrypt_me.txt"
cd %decrypt_path%
call :search
if %b%==0 timeout 3 /nobreak >nul & exit
echo files:%b%>>"%cdnow%/decrypt_me.txt"
:decrypt
set c=0
cd "%cdnow%"
:decrypt_loop
set /a c=%c%+1
for /f "tokens=1* delims=:" %%i in ('findstr /b "%c%:" "%cdnow%\decrypt_me.txt"') do set "file_now=%%j"
echo [%c%/%b%] Encrypt: %file_now%
hcrypt.exe --decrypt --file=%file_now% --pass=%pass%
if %errorlevel%==1 cls & echo Falsches Passwort! & color c & timeout 5 /nobreak >nul & exit
if %c%==%b% goto delete_all
goto decrypt_loop
:delete_all
del /S "%decrypt_path%\*.data.hcrypt" >NUL
del /S "%decrypt_path%\*.head.hcrypt" >NUL
cls
color a
echo Erfolgreich!
timeout 4 /nobreak >nul
exit
:search
for /f "delims=" %%a IN ('dir /b /s *.data.hcrypt') do set a="%%a" & call :search1 %%a
goto end
:search1
set /a b=%b%+1
echo %b%:%a%>>"%cdnow%/decrypt_me.txt"
echo [%b%] Found: %a%
goto :eof
:end