:: разворачивает ЗУП dt-шник с пустыми расширениями
:: (для изменения списка расширений например)
@echo off && cd /d %~dp0\..
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do @set %%K%%L
chcp 65001
2>nul rd /S /Q cfg\zupExt.dt
call vrunner init-dev --ibconnection /F".tmpib.zup" --nocacheuse --dt cfg\zupExt.dt 
C:\progra~2\1cv8\8.3.18.1483\bin\1cv8.exe config /f.tmpib.zup 