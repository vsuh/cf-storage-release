::�ਯ� ��ࠢ��� ���쬮 � ���ᠭ��� ५��� � �ਫ������ ��⮪���� ���������
::
::               
::                                                                 01/2022@VSCraft
@setlocal ENABLEDELAYEDEXPANSION
@echo off 
Set nm_uat=���
Set nm_zup=���
Set nm_bnu=����
cd %~dp0\.. 
>nul chcp 866
if _%1_==__ (echo �ॡ���� ��ࠬ��� - ��
	goto help_me
	)
Set to=ivanova@moscollector.ru
Set cf.pref=out\%1

Set exe=C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE
for /f "usebackq" %%I in (`dir /b /o:d /a:d "%cf.pref%\0*"`) do (
	Set "cf.dir=%cf.pref%\%%I"
)
for %%I in (%cf.dir%\*.mxl) do Set mxl=%%~dpnxI
for /F %%I in ("%cf.dir%") do Set rn=%%~nxI

py cmd\tg_info.py "��ନ஢�� ५�� !nm_%1! {{b%rn%b}}"
"%exe%" /c ipm.note /a %mxl% /m "%to%&subject=�����%%20!nm_%1!%%20�%%20%rn%&body=���ᠭ��%%20��%%20��������"
 


exit
:help_me
echo.
echo �ᯮ�짮�����:
echo 	%~nx0 ��
echo 	��� �� - bnu, zup ��� uat
