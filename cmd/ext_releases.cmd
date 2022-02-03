:: Версия 4. Формирование файла|ов релиза расширений конфигурации через существующую (связанную с хранилищем) ИБ
:: sukhikh@moscollector.ru									VSCraft@2021

@echo off && cd /d %~dp0\..
chcp 65001>nul
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
set log=log\zup_cfe.log
2>nul md out\ext

echo ----		[ %n0 ]			----					>>%log%
echo %date% %time% Начало. Рабочий каталог %cd%
echo %date% %time% Начало. Рабочий каталог %cd%						>>%log%
::ECHO %time% Обновление конфигурации ИБ из хранилища
::ECHO %time% Обновление конфигурации ИБ из хранилища					>>%log%
::%exe1c% /@"src\steps\s002.txt"
ECHO %time%(%ERRORLEVEL%) Обновление расширения "грРасширениеЗУП" из хранилища		>>%log%
ECHO %time%(%ERRORLEVEL%) Обновление расширения "грРасширениеЗУП" из хранилища
%exe1c% /@"src\steps\s004.txt"
ECHO %time%(%ERRORLEVEL%) Формирование файла отчета по расширению "грРасширениеЗУП"	>>%log%
ECHO %time%(%ERRORLEVEL%) Формирование файла отчета по расширению "грРасширениеЗУП"
%exe1c% /@"src\steps\s005.txt"
ECHO %time%(%ERRORLEVEL%) Обновление расширения "МК_Доработки" из хранилища		>>%log%
ECHO %time%(%ERRORLEVEL%) Обновление расширения "МК_Доработки" из хранилища
%exe1c% /@"src\steps\s006.txt"
ECHO %time%(%ERRORLEVEL%) Формирование файла отчета по расширению "МК_Доработки"	>>%log%
ECHO %time%(%ERRORLEVEL%) Формирование файла отчета по расширению "МК_Доработки"
%exe1c% /@"src\steps\s007.txt"
ECHO %time%(%ERRORLEVEL%) Получения файла релиза расширения out\ext\МК_Доработки	>>%log%
ECHO %time%(%ERRORLEVEL%) Получения файла релиза расширения "МК_Доработки"
%exe1c% /@"src\steps\s008.txt"
ECHO %time%(%ERRORLEVEL%) Получения файла релиза расширения out\ext\грРасширениеЗУП	>>%log%
ECHO %time%(%ERRORLEVEL%) Получения файла релиза расширения "грРасширениеЗУП"
%exe1c% /@"src\steps\s009.txt"
ECHO %time%(%ERRORLEVEL%)								>>%log%
ECHO %time%(%ERRORLEVEL%)
ECHO %date% %time% Завершено								>>%log%
ECHO %date% %time% Завершено. Файлы релизов в out\ext; протокол в %log%

