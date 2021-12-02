chcp 65001>nul
set Version=8.3.18.1483
set Path32="C:\Program Files (x86)\1cv8\%Version%\bin\1cv8.exe"

rd /q /s "v8r_TempDB"
%Path32% /@"step0.txt"
rem Обновление основной конфигурации
%Path32% /@"step1.txt"
rem Обновление первого расширения
%Path32% /@"step2.txt"
%Path32% /@"step3.txt"
rem Обновление второго расширения
::%Path32% /@"step4.txt"
::%Path32% /@"step5.txt"
