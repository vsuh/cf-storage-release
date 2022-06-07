:: -*- coding: cp1251 -*-
:: скрипт загружает файл конфигурации в тестовую ИБ, указанную в параметре запуска на сервере %srv%
:: файл конфигурации берется из последнего подкаталога в каталоге out\ИБ
:: Вер. 1.0.2                                                                       12/2021@VSCraft

@echo off 
setlocal enabledelayedexpansion
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do @set %%K%%L

>nul chcp 1251 && cd %~dp0\..\out
if NOT exist %tmp% md %tmp%

Set tm.start=%TIME%
Set LOGOS_LEVEL=INFO
Set tim=-
Set srv=lob-1c-test
if .%1.==.. (	 echo требуется обязательный параметр - имя тестовой ИБ
	goto help_me
	) ELSE ( Set "ib=%1" )


Set cf.pref=%ib:~0,6%
Set cf.pref=%cf.pref:mc_=%

IF exist %2 ( Set "cf.dir=%2" )
if .%2.==.. (	@echo требуется параметр - номер или каталог релиза. Подбираю последний 
	for /f "usebackq" %%I in (`dir /b /o:d /a:d "%cf.pref%\0*"`) do (
		Set "cf.dir=%cf.pref%\%%I"
	)
) else (
  		Set cf.dir=00000%2
  		Set cf.dir=!cf.pref!\!cf.dir:~-4!
)
IF NOT EXIST !cf.dir! (
	echo Каталог релиза "!cf.dir!" не найден  
	goto help_me
)

Set cf.src=!cf.pref!\!cf.dir:~-4!
echo беру релиз из каталога !cf.src!

For %%I in (%cf.dir%\*cf) do SET cf=%%I

if NOT exist %cf% (
	echo не найден файл релиза %cf%
	goto help_me

)

echo %date% %time% обновляется ИБ %v8.srv1C%\%ib% файлом %cf%
Set sess.env=--ras %v8.srv1C% --try 3 --db %ib% %v8.cl_auth% %v8.ib_auth% %v8.Ver1C%


timeout 15
call vrunner session kill %sess.env% %v8.uccode% --lockmessage "Загрузка конфигурации с %TIME% из !cf.dir!" --ibconnection /s%v8.srv1C%\%ib%
call vrunner load -s %cf%          --debuglogfile %log%\load-cf-%ib%.log --ibconnection /s%v8.srv1C%\%ib%  && ^
call vrunner updatedb --nocacheuse --debuglogfile %log%\update-cf-%ib%.log --ibconnection /s%v8.srv1C%\%ib%
Set err=%ERRORLEVEL%
Set tm.end=%TIME%
if %err%==0 (
	cd ..
	call :timer "%tm.start%" "%tm.end%"
        echo ^>^>^> duration: !tim!
	py cmd\tg_info.py "Обновление {{b%v8.srv1C%\%ib%b}} файлом %cf% завершено в %tm.end% за !tim!"
	)
call vrunner session unlock %sess.env%
echo %date% %time% Finished. RC=%err%

EXIT
:help_me

echo.&echo.&echo.
echo Использование:
echo 	%~nx0  ИМЯ_ТЕСТОВОЙ_ИБ  [НОМЕР_ИЛИ_КАТАЛОГ_РЕЛИЗА]
echo.&echo.


EXIT

:timer
:: требует двух параметров - время начала и время конца
:: результат сохраняет в переменную TIM

set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%~1") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%~2") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%

if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours% 
if 1%ms% lss 100 set ms=0%ms%

set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
:: echo command took %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)

set tim=%hours%:%mins%:%secs% (%totalsecs%,%ms%s)
if .%hours%. == .0. (
	set tim=%mins%:%secs% [%totalsecs%,%ms%s]
	if .%mins%. == .0. set tim=%secs% [%totalsecs%,%ms%s]
	)

exit /b
