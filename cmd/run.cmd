:: ��ନ஢���� ५���                                                                              VSCraft@2022
:: ��ਯ� �믮���� 蠣�:
::    - ����᪠�� os-�ਯ�, �ନ���騩 䠩�� ५���
::    - ��ࠢ��� 㢥�������� � ⥫��ࠬ
::    - ������� ����� ५��� �� ��㣮� ��
::    - �ନ��� ५��� ���७�� ��� ���
::    - ������� ���७�� �� ��㣮� ��
@echo off && cd %~dp0\.. 
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
if .%1.==.. exit


call oscript src\storage-report.os !cf.%1!
call cmd\info.cmd %1

for /f "usebackq" %%I in (`dir /b /o:d /a:d "out\%1\0*"`) do (
	Set "cf.dir=%1\%%I"
)

nul 2>md "%cf.copy%\%cf.dir%"
echo d | xcopy /s out\%cf.dir% "%cf.copy%\%cf.dir%"
if .%1.==.zup. (
	call cmd\ext.cmd
	for /f "delims=" %%f in ('dir /s /b out\ext\*.cfe out\ext\*.mxl') do copy %%f "%cf.copy%\%cf.dir%"
	)

2>nul rd /Q /S %TEMP%
EXIT
