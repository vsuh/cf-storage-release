:: �ਯ� ������� ����� ५��� � ����� 䠩��� � ��⠫��� �� ���� �����, 㪠����� � ��ࠬ����
:: ���ਬ��:
:: 		corr_release.cmd .\0012.01 0012.03
::                                                                                01/2022@VSCraft
@setlocal enabledelayedexpansion
@echo off && cd %~dp0
if _%2_==__ (
	echo �ॡ���� 㪠���� ����� ������ ५���
	goto help_me 7
	)
if _%1_==__ (
	echo �ॡ���� 㪠���� ��� ��⠫��� � ५����
	goto help_me 7
	)

if NOT exist %1 (
	echo ��⠫�� ५���� %1 �� �����㦥�
	goto help_me 7
	)

if exist %2 (
	echo ��⠫�� ������ ५��� %2 㦥 �������
	goto help_me 7
	)

for /f %%I in ("%1") do set src=%%~nxI
if _%src%_==_%2_ (
	echo ��ப� ��室���� � १������饣� ५��� ᮢ������: %src% == %2 
	goto help_me 7
	)

set trg=%2
echo ������� ����� ५��� %src% ==^> %2
cd %1
for %%F in (*.*) do (
	Set file=%%F
	echo !file!  ---^>^>  !file:%src%=%trg%!
	ren !file! !file:%src%=%trg%!
	)
cd ..
ren %src% %trg%
exit


:help_me A
echo.
echo.
echo �ᯮ�짮�����:
echo 		%0 ������� �����_������_������
echo.
echo.
echo ���ਬ��:
echo 		%0 .\0012.01 0012.03
exit %1
