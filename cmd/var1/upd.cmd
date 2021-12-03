:: Версия 2. Формирование файла|ов релиза расштрений конфигурации
:: не работает
@echo off
chcp 65001>nul
set Version=8.3.18.1483
set Path32="C:\Program Files (x86)\1cv8\%Version%\bin\1cv8.exe"

echo %date% %time% start from folder %~dp0
rd /q /s "v8r_TempDB"
%Path32% /@"step0.txt"
ECHO %time% Обновление основной конфигурации
%Path32% /@"step1.txt"
ECHO %time% Обновление первого расширения
%Path32% /@"step2.txt"
%Path32% /@"step3.txt"
rem Обновление второго расширения
::%Path32% /@"step4.txt"
::%Path32% /@"step5.txt"
echo %date% %time% finish

call %Path32% /F"v8r_TempDB"
