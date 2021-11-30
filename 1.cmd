@echo off
:: codepage 1251
>nul chcp 1251


:: set variable 1C
set Version=8.3.18.1483
set Path32="C:\Program Files (x86)\1cv8\%Version%\bin\1cv8.exe"
set Path64="C:\Program Files\1cv8\%Version%\bin\1cv8.exe"
set Log="updDebug.log"

:: set variable DataBase
set SrvName=Server1C
set DBName=ServerBase
set Base=/F "v8tmp"
set LoginDB=""
set PassDB=""
set LoginHRN="auto"
set PassHRN=":fhtyyst{jkjgtymj"

:: set variable Repository
set PathHRN="tcp://hr1c/zup31"
set PathHRNExt="tcp://hr1c/zup31_ext"
set LoginHRNext="auto"
set PassHRNext="ibitxrbbujkjxrb"
set ExtName="грРасширениеЗУП"

:: start update
cls & rd /q /s %Base%
@echo -----------------------------------------------------------------------
@echo Создание пустой базы call %Path32% CREATEINFOBASE File="%Base:/F=%" /Out %Log%
@echo Создание пустой базы >> "00_cre.log"
call %Path32% CREATEINFOBASE File="%Base:/F=%" /Out %Log%
  pause
@echo -----------------------------------------------------------------------
@echo Обновление расширения из хранилища:
@echo Обновление расширения из хранилища >> "00_cre.log"
@echo %Path32% DESIGNER %Base% /Out %Log% /N %LoginDB% /P %PassDB% /ConfigurationRepositoryF %PathHRNExt% /ConfigurationRepositoryN %LoginHRNext% /ConfigurationRepositoryP %PassHRNext% /ConfigurationRepositoryUpdateCfg -force -Extension %ExtName%
call %Path32% DESIGNER %Base% /Out %Log% /N %LoginDB% /P %PassDB% /ConfigurationRepositoryF %PathHRNExt% /ConfigurationRepositoryN %LoginHRNext% /ConfigurationRepositoryP %PassHRNext% /ConfigurationRepositoryUpdateCfg -force -Extension %ExtName%
@echo RC: %ERRORLEVEL%

@echo -----------------------------------------------------------------------
@echo Обновление конфигурации из хранилища и обновление БД:
@echo Обновление конфигурации из хранилища и обновление БД >> "00_cre.log"
@echo %Path32% DESIGNER %Base% /Out %Log% /N %LoginDB% /P %PassDB% /ConfigurationRepositoryF %PathHRN% /ConfigurationRepositoryN %LoginHRN% /ConfigurationRepositoryP %PassHRN% /ConfigurationRepositoryUpdateCfg -force /UpdateDBCfg -Server
call %Path32% DESIGNER %Base% /Out %Log% /N %LoginDB% /P %PassDB% /ConfigurationRepositoryF %PathHRN% /ConfigurationRepositoryN %LoginHRN% /ConfigurationRepositoryP %PassHRN% /ConfigurationRepositoryUpdateCfg -force /UpdateDBCfg -Server
@echo RC: %ERRORLEVEL%
