:: ������ ��������� ���� ������������ � �������� ��, ��������� � ��������� ������� �� ������� %srv%
:: ���� ������������ ������� �� ���������� ����������� � �������� out\��
::                                                                                12/2021@VSCraft

@echo off 
setlocal enabledelayedexpansion
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do @set %%K%%L

>nul chcp 1251 && cd %~dp0\..\out
Set tm.start=%TIME%
::Set LOGOS_LEVEL=DEBUG
Set srv=lob-1c-test
if .%1.==.. (	 echo ��������� ������������ �������� - ��� �������� ��
	goto help_me
	) ELSE ( Set "ib=%1" )


Set cf.pref=%ib:~0,6%
Set cf.pref=%cf.pref:mc_=%

IF exist %2 ( Set "cf.dir=%2" )
if .%2.==.. (	@echo ��������� �������� - ����� ��� ������� ������. �������� ��������� 
	for /f "usebackq" %%I in (`dir /b /o:d /a:d "%cf.pref%\0*"`) do (
		Set "cf.dir=%cf.pref%\%%I"
	)
) else (
  		Set cf.dir=00000%2
  		Set cf.dir=!cf.pref!\!cf.dir:~-4!
)
IF NOT EXIST !cf.dir! (
	echo ������� ������ "!cf.dir!" �� ������  
	goto help_me
)

echo ���� ����� �� �������� !cf.dir!

For %%I in (%cf.dir%\*cf) do SET cf=%%I

if NOT exist %cf% (
	echo �� ������ ���� ������ %cf%
	goto help_me

)

echo %date% %time% ����������� �� %srv%\%ib% ������ %cf%

timeout 15
call vrunner load -s %cf% --ibconnection /s%srv%\%ib% --v8version 8.3.18.1483 && ^
call vrunner updatedb --ibconnection /s%srv%\%ib%  --nocacheuse --v8version 8.3.18.1483
Set err=%ERRORLEVEL%
Set tm.end=%TIME%
if %err%==0 (
	py ..\cmd\tg_info.py "������� � %tm.start% ���������� %srv%\%ib% ������ %cf% ��������� � %tm.end%"
	)
echo %date% %time% Finished. RC=%err%

EXIT
:help_me

echo.&echo.&echo.
echo �������������:
echo 	%~nx0  ���_��������_��  [�����_���_�������_������]
echo.&echo.
exit
