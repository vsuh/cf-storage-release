:: скрипт по имени ИБ: "zup" "bnu" или "uat" находит самый свежий dt-шник и 
:: - загружает его в файловую базу bases\%IB%
:: - обновляет конфигурацию из хранилища
:: 
::                                                                                                 VSCraft@2022
@echo off & cd \
setlocal ENABLEDELAYEDEXPANSION
if ~%1~==~~ ( 
	@echo Не указан параметр - будет использован 'bnu'
	timeout 900
	set pr=bnu
	) ELSE (
	set pr=%1
	)

2>nul md TEMP && set temp=temp
set tmp=temp
if ~%pr%~==~~ (
	echo %date% %time% parameter "ib" needed
	exit
	)
for /f %%I in ('dir /b *%pr%*.dt 2^>nul') DO Set dt=%%I

if ~%dt%~==~~ (
	echo %date% %time% dt file for "%pr%" not found
	For /F %%O in ('dir /o:D /b "\\10.51.8.10\Backups\1C_BACKUPS\mc_%pr%\*.dt"') do Set ldt=%%O
	copy \\10.51.8.10\Backups\1C_BACKUPS\mc_%pr%\!ldt! .
        Set dt=%ldt%
	)
if NOT exist %dt% (
	echo %date% %time% dt file not found
	exit
) ELSE (
	echo %date% %time% last dt from backup copied - %dt%
)

call :strge_init %pr%

if NOT defined as (
	echo %date% %time% storage address for "%pr%" not found
	exit
	)
if NOT defined spw (
	Set sauth=--storage-user auto
	) ELSE (
	Set sauth=--storage-user auto --storage-pwd %spw%
	)
echo %date% %time% загрузка "%dt%" в ИБ %ibc:/F=%
echo %date% %time% @call vrunner init-dev --dt %dt% --ibconnection %ibc% --storage --storage-name %as% %sauth% 
::  Для MYSQL  @call vrunner init-dev --dt %dt% --ibconnection "/Smysql\zup_storage"  --storage --storage-name %as% %sauth% --db-user master --db-pwd ,tutvjn
@call vrunner init-dev --dt %dt% --ibconnection %ibc% --storage --storage-name %as% %sauth% --db-user master --db-pwd ,tutvjn 
echo %date% %time% @call vrunner bindrepo %as% auto %spw% --ibconnection %ibc% --BindAlreadyBindedUser  --nocacheuse --db-user master --db-pwd ,tutvjn 
@call vrunner bindrepo %as% Сухих 0147 --ibconnection %ibc% --BindAlreadyBindedUser  --nocacheuse --db-user master --db-pwd ,tutvjn 
del %dt%
EXIT

:strge_init
Set as=
Set spw=
if ~%1~==~uat~ (
	Set as=tcp://hr1c/uat
	Set spw=cbcntvfnbpfwbz
	Set ibc=/F"E:\bases\uat.storage"
	)
if ~%1~==~bnu~ (
	Set as=tcp://hr1c/KUCY
	Set spw=Njkmrjvfhxtkkj
	Set ibc=/F"E:\bases\bnu.storage"
	)
if ~%1~==~zup~ (
	Set as=tcp://hr1c/ZUP31
	Set spw=Htpjk.wbz
	Set ibc=/F"E:\bases\zup.storage"
	)

