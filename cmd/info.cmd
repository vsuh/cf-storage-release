:: -*- coding: cp866 -*-
::�ਯ� ��ࠢ��� ���쬮 � ���ᠭ��� ५��� � �ਫ������ ��⮪���� ���������
::
::               
::                                                                 01/2022@VSCraft
@echo off & cd %~dp0\.. 
setlocal ENABLEDELAYEDEXPANSION
if exist .env FOR /F "eol=# tokens=1,*" %%K IN (.env) do @set %%K%%L

>nul chcp 866
if _%1_==__ (echo �ॡ���� ��ࠬ��� - ��
	goto help_me
	)

Set cf.pref=out\%1


for /f "usebackq" %%I in (`dir /b /o:d /a:d "%cf.pref%\0*"`) do (
	Set "cf.dir=%cf.pref%\%%I"
)
for %%I in (%cf.dir%\*.mxl) do Set mxl=%%~dpnxI
for /F %%I in ("%cf.dir%") do Set rn=%%~nxI
echo ^>^>^>^>^> ��� ��: !nm_%1!
py cmd\tg_info.py "��ନ஢�� ५�� !nm_%1! {{b%rn%b}} �� %2"
"%exeOutlook%" /c ipm.note /a %mxl% /m "%info_to%&subject=�����%%20!nm_%1!%%20�%%20%rn%&body=���ᠭ��%%20��%%20��������"
 


exit /b
:help_me
echo.
echo �ᯮ�짮�����:
echo 	%~nx0 ��
echo 	��� �� - bnu, zup ��� uat
