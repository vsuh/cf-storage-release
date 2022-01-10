:: скрипт изменяет номер релиза в имени файлов и каталога на новый номер, указанный в параметрах
:: например:
:: 		corr_release.cmd .\0012.01 0012.03
::                                                                                01/2022@VSCraft
@setlocal enabledelayedexpansion
@echo off && cd %~dp0
if _%2_==__ (
	echo требуется указать номер нового релиза
	goto help_me 7
	)
if _%1_==__ (
	echo требуется указать имя каталога с релизом
	goto help_me 7
	)

if NOT exist %1 (
	echo каталог релизов %1 не обнаружен
	goto help_me 7
	)

if exist %2 (
	echo каталог нового релиза %2 уже существует
	goto help_me 7
	)

for /f %%I in ("%1") do set src=%%~nxI
if _%src%_==_%2_ (
	echo строки исходного и результирующего релиза совпадают: %src% == %2 
	goto help_me 7
	)

set trg=%2
echo Изменяю номер релиза %src% ==^> %2
cd %1
for %%F in (*.*) do (
	Set file=%%F
	echo !file!  ---^>^>  !file:%src%=%trg%!
	ren !file! !file:%src%=%trg%!
	)
cd ..
ren %src% %trg%
exit


:help_me A
echo.
echo.
echo Использование:
echo 		%0 КАТАЛОГ НОМЕР_НОВОГО_РЕЛИЗА
echo.
echo.
echo например:
echo 		%0 .\0012.01 0012.03
exit %1
