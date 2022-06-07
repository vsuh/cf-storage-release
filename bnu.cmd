@if %1~==~ (
	Set ob=1
	) ELSE (
	Set ob=%1
)
@IF %ob%==0 (
echo 
^*^*^* будет записан ОСНОВНОЙ релиз 
) ELSE (
echo 
^*^*^* будет записан ИСПРАВИТЕЛЬНЫЙ релиз 
)
@timeout 20

@call cmd\run %~n0 %ob%

if .%2.==.. exit

@call cmd\upd %2
