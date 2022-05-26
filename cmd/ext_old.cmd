
:: -*- coding: utf-8 -*-
:: Версия 0.6 Формирование файла|ов релиза расширений конфигурации 
:: из существующей (связанной с хранилищем) информационной базы
:: параметры запуска шагов, описаны в файлах *.stp в каталоге steps
::
:: sukhikh@moscollector.ru									VSCraft@2021

@echo off && cd /d %~dp0\..
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
(Set temp=TEMP) & (Set tmp=TEMP) & (if NOT exist %tmp% md %tmp%) & (chcp 65001>nul)
set log=log\zup_cfe.log
set ibc=/F.tmpib.zup
set cf.exts=МК_Доработки ВакцинацияCOVID19 грРасширениеЗУП
set addr.ВакцинацияCOVID19="tcp://hr1c/ZUP31_ext_COVID19"
set addr.грРасширениеЗУП="tcp://hr1c/ZUP31_ext"
set addr.МК_Доработки="tcp://hr1c/ZUP31_ext_MC"
cd.?>%log% 
2>nul md out\ext

call :log ----			[ %~n0 ]			----			
call :log  Started. Working folder %cd%

call :log  Make clean IB in %ibc:/F=%
call vrunner init-dev --ibconnection %ibc% --nocacheuse --dt cfg\zupExt.dt 

for %%e in (%cf.exts%) DO @(
	call :log  ^*^*^*^* reload extension "%%e" from storage !addr.%%e!
	call vrunner loadrepo --ibconnection %ibc% --nocacheuse --storage-name !addr.%%e! --storage-user СухихВЮ --storage-pwd 0147 --extension "%%e"

	call :log  ^*^*^*^* Выгрузка файла расширения "%%e"
	call vrunner unloadext "out\ext\%%e\%%e.cfe" "%%e" --ibconnection %ibc%
	)

call :log  ^*^*^*^* Применение изменений конфигурации
call vrunner updatedb --ibconnection %ibc%

::#C:\progra~2\1cv8\8.3.18.1483\bin\1cv8.exe config /f.tmpib.zup 
@rd /Q /S %ibc:/F=%
@exit /b

for %%S in (cmd\steps\*.stp) do (
	Set step=%%~nxS

        For /F "tokens=1,*" %%D in (cmd\steps\descript.ion) do (
        	IF /I .%%~nxS.==.%%D. Set Dsc=%%E
        )

	echo %date% %time% {prvRC:!err!}[!step:.stp=!] !Dsc!				>>%log%%
	echo %date% %time% {prvRC:!err!}[!step:.stp=!] !Dsc!

	%exe1c% /@%%S
	Set err=%ERRORLEVEL%
        for /f "delims=" %%i in (TEMP\EXTzup.log) do @set lll=%%i
	echo %date% %time% [%%S] RESULT=%err% :						>>%log%%
	type TEMP\EXTzup.log								>>%log%%
	echo %date% %time% result=%err% !err! !lll!
)


::rd /q /s %ibc:/F=% 2>nul

:log
echo %date% %time% %*
echo %date% %time% %*>>%log%
