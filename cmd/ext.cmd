:: Версия 5. Формирование файла|ов релиза расширений конфигурации через существующую (связанную с хранилищем) ИБ
:: sukhikh@moscollector.ru									VSCraft@2021

@echo off && cd /d %~dp0\..
setlocal ENABLEDELAYEDEXPANSION
::chcp 65001>nul
set Version=8.3.18.1483
set exe1c="C:\Program Files (x86)\1cv8\%Version%\bin\1cv8.exe"
set log=log\zup_cfe.log
2>nul md out\ext

echo ----			[ %~n0 ]			----			>>%log%
echo %date% %time% Started. Working folder %cd%
echo %date% %time% Started. Working folder %cd%						>>%log%

for %%S in (src\steps\*.stp) do (
	Set step=%%~nxS
        For /F "tokens=1,*" %%D in (src\steps\descript.ion) do (
        	IF /I .%%~nxS.==.%%D. Set Dsc=%%E
        )


	echo %time% [!step:.stp=!]							>>%log%%
	echo %time% {!err!}[!step:.stp=!] !Dsc!

	%exe1c% /@%%S
	Set err=%ERRORLEVEL%
	echo %time% result=%ERRORLEVEL%							>>%log%%
)


