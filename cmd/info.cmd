::скрипт отправляет письмо с описанием релиза и приложенным протоколом изменений
::
::               
::                                                                 01/2022@VSCraft
@echo off 
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do @set %%K%%L
cd %~dp0\.. 
>nul chcp 866
if _%1_==__ (echo требуется параметр - ИБ
	goto help_me
	)

Set cf.pref=out\%1


for /f "usebackq" %%I in (`dir /b /o:d /a:d "%cf.pref%\0*"`) do (
	Set "cf.dir=%cf.pref%\%%I"
)
for %%I in (%cf.dir%\*.mxl) do Set mxl=%%~dpnxI
for /F %%I in ("%cf.dir%") do Set rn=%%~nxI

py cmd\tg_info.py "сформирован релиз !nm_%1! {{b%rn%b}}"
"exeOutlook%" /c ipm.note /a %mxl% /m "%info_to%&subject=Релиз%%20!nm_%1!%%20№%%20%rn%&body=Описание%%20во%%20вложении"
 


exit
:help_me
echo.
echo Использование:
echo 	%~nx0 ИБ
echo 	где ИБ - bnu, zup или uat
