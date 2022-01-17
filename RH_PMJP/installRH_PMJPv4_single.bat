@echo off

rem +---------------------------------------Descrição--------------------------------------------+
rem Copia o arquivo especificado em "fileName" para a pasta do usuário que executar este script.
rem criando o atalho na sua na área de trabalho.
rem +--------------------------------------------------------------------------------------------+

set source=\\IP_SERVER\arquivos\sistemas
set fileName=RH_PMJP.bat

rem Se a pasta "ipmjp" não existir, ela será criada
if not exist "%userprofile%\ipmjp" (
	mkdir "%userprofile%\ipmjp"
)

rem Copia o "RH_PMJP.exe" para a pasta "ipmjp" de todos usuários
xcopy /y /d "%source%\%fileName%" "%userprofile%\ipmjp\"

rem Cria o atalho do "RH_PMJP.exe" na Área de trabalho do usuários
copy /y "%source%\RH_PMJP.lnk" "%userprofile%\Desktop\RH_PMJP.lnk"

exit /b 0
