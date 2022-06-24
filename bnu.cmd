@echo off
if %1~==~ (
	Set ob=1
	) ELSE (
	Set ts=%1
	if /I "%ts:~0,3%"=="mc_" (
	  Set ob=1
	  Set ib=%1
	) 
)
IF %ob%==0 (
echo ^*^*^* будет записан ОСНОВНОЙ релиз 
) ELSE (
echo ^*^*^* будет записан ИСПРАВИТЕЛЬНЫЙ релиз 
)
timeout 20
echo cmd\run %~n0 %ob%
call cmd\run %~n0 %ob%

if .%ib%.==.. exit

call cmd\upd %ib%
