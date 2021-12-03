:: Попытка выгрузить релиз расширения №2
:: по мотивам дисуссии в https://infostart.ru/journal/news/mir-1s/ne-zabyvayte-o-vozmozhnosti-sozdat-khranilishche-konfiguratsii-dlya-rasshireniy_952832/
:: не работает
Set "Version=8.3.18.1483"
Set exe1c="C:\Program Files (x86)\1cv8\%Version%\bin\1cv8.exe"
Set "ib=v8r_TempDB"

@echo %date% %time% Start
::2>nul del *.log
2>nul rd /q /s %ib%

%exe1c% @st00.txt 
%exe1c% @st01.txt 
%exe1c% @st02.txt

%exe1c% config /f%ib%

@echo %date% %time% Finished


