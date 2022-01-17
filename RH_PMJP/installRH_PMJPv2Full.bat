@echo off

rem +---------------------------------------Descrição------------------------------------------------------+
rem Copia o arquivo especificado em "fileName" para a pasta dos usuários que já fizeram login na máquina e
rem cria o atalho na área de trabalho.
rem +------------------------------------------------------------------------------------------------------+

set source=\\IP_SERVER\arquivos\sistemas
set fileName=RH_PMJP.bat
set listUsers=lista.txt
set newListUsers=novaLista.txt

rem Cria uma lista de usuários
dir c:\users /b > c:\windows\temp\%listUsers% && findstr /v "Public" c:\windows\temp\%listUsers% > c:\windows\temp\%newListUsers%

rem Percorre a lista
for /F "tokens=*" %%A in (c:\windows\temp\%newListUsers%) do (

	rem Se a pasta "ipmjp" não existir, ela será criada
	if not exist "c:\users\%%A\ipmjp" (
		mkdir "c:\users\%%A\ipmjp"
	)

	rem Copia o "RH_PMJP.exe" para a pasta "ipmjp" de todos usuários
	xcopy /y /d "%source%\%fileName%" "c:\users\%%A\ipmjp\"

	rem Cria o atalho do "RH_PMJP.exe" para todos usuários
 	if exist "c:\users\%%A\Desktop\RH_PMJP" (
		(del "c:\users\%%A\Desktop\RH_PMJP") && (mklink "c:\users\%%A\Desktop\RH_PMJP" "c:\users\%%A\ipmjp\%fileName%")
	) else (
		mklink "c:\users\%%A\Desktop\RH_PMJP" "c:\users\%%A\ipmjp\%fileName%"
	)

)
pause
rem exit /b 0
