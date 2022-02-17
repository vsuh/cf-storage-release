:: -*- coding: utf-8 -*-
:: Версия 0.6 Формирование файла|ов релиза расширений конфигурации 
:: из существующей (связанной с хранилищем) информационной базы
:: параметры запуска шагов, описаны в файлах *.stp в каталоге steps
::
:: sukhikh@moscollector.ru									VSCraft@2021

@echo off && cd /d %~dp0\..
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
chcp 65001>nul
set log=log\zup_cfe.log
cd.?>%log% 
2>nul md out\ext

echo ----			[ %~n0 ]			----			>>%log%
echo %date% %time% Started. Working folder %cd%
echo %date% %time% Started. Working folder %cd%						>>%log%


2>nul verify on
for %%S in (cmd\steps\*.stp) do (
	Set step=%%~nxS

        For /F "tokens=1,*" %%D in (cmd\steps\descript.ion) do (
        	IF /I .%%~nxS.==.%%D. Set Dsc=%%E
        )

	echo %date% %time% {prvRC:!err!}[!step:.stp=!] !Dsc!				>>%log%%
	echo %date% %time% {prvRC:!err!}[!step:.stp=!] !Dsc!

	%exe1c% /@%%S
	Set err=%ERRORLEVEL%
	echo %date% %time% result=%err%							>>%log%%
)


