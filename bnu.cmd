@echo off
if "%2"=="" ( Set ob="1" ) ELSE ( Set ob="%2" )
if NOT %1~==~  Set ib="%1"
IF %ob%==0 (
echo ^*^*^* �㤥� ����ᠭ �������� ५�� 
) ELSE (
echo ^*^*^* �㤥� ����ᠭ �������������� ५�� 
)
timeout 20
echo cmd\run %~n0 %ob%

call cmd\run %~n0 %ob%

if .%ib%.==.. exit

call cmd\upd %ib%
