:: -*- coding: cp866 -*-
::
:: �������� ���⮩  ��
:: ����㧪� � ��� ���䨣��樨 �� �࠭���� ���
:: �ਬ������ ��������� ���䨣��樨
:: ����㧪� � �� ���७��

@echo off && cd /d %~dp0\..
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do set %%K%%L
(Set temp=TEMP) & (Set tmp=TEMP) & (if NOT exist %tmp% md %tmp%)
Set ib=/F.extZup

2>nul rd /S /Q %ib:/F=% 

@call vrunner init-dev --dev --storage --storage-name %addr.zup% --storage-user ���傞 --storage-pwd 0147 --ibconnection %ib%
@call vrunner updatedb --ibconnection %ib%

for %%E in (%cf.exts%) DO @(
    @call vrunner loadext   -f out\ext\%%E\%%E.cfe --updatedb --extension %%E --ibconnection %ib%
    @call vrunner loadrepo  --extension %%E --storage-name !addr.%%E! %storage_auth% --ibconnection %ib%
    @call vrunner unloadext out\ext\%%E\%%E.cfe %%E --ibconnection %ib%
    @call vrunner designer  --additional "/ConfigurationRepositoryReport out\ext\%%E\%%E.mxl -NBegin 1 -NEnd 99999 -GroupByComment -Extension %%E" --storage-name !addr.%%E! %storage_auth% --ibconnection %ib%
)
2>nul rd /S /Q %temp%
2>nul rd /S /Q %ib% 
exit /b

