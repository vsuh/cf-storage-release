:: -*- coding: cp866 -*-
:: Формирование релиза                                                                              VSCraft@2022
:: Скрипт выполняет шаги:
::    - запускает os-скрипт, формирующий файлы релиза
::    - отправляет уведомление в телеграм
::    - копирует папку релиза на другой ПК
::    - формирует релизы расширений для ЗУП
::    - копирует расширения на другой ПК
:: Запускается с двумя параметрами - тег конфигурации и признаком исправительного релиза (0/1)
:: > run bnu 0
@echo off && cd %~dp0\.. 
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
if .%2.==.. exit
(Set temp=TEMP) & (Set tmp=TEMP) & (if NOT exist %tmp% md %tmp%)
Set beg=%time%
::Set logos_level=DEBUG

call oscript src\storage-report.os !cf.%1! %2

for /f "usebackq" %%I in (`dir /b /o:d /a:d "out\%1\0*"`) do (
	Set "cf.dir=%1\%%I"
)

2>nul md "%cf.copy%\%cf.dir%"
if EXIST %cf.copy%\%cf.dir% echo d | xcopy /s out\%cf.dir% "%cf.copy%\%cf.dir%"
if .%1.==.zup. (
	call cmd\ext.cmd
	for /f "delims=" %%f in ('dir /s /b out\ext\*.cfe out\ext\*.mxl') do copy %%f "%cf.copy%\%cf.dir%"
	)
call :timer "%beg%" "%time%"
echo Это заняло %tim% {!tim!}
call cmd\info.cmd %1 %tim%
2>nul rd /Q /S %TEMP%

EXIT /b






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

set tim=%hours%:%mins%:%secs% [%totalsecs%,%ms%s]
if .%hours%. == .0. (
	set tim=%mins%:%secs% [%totalsecs%,%ms%s]
	if .%mins%. == .0. set tim=%secs% [%totalsecs%,%ms%s]
	)

exit /b