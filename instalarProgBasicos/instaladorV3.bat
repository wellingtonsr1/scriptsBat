@echo off
cls
rem +--------------------------------------------------Descrição-------------------------------------------------------+
rem | - Instala os programas básicos; Renomeia o computador; configura os dados de rede(IP, Máscara, Gateway e DNS)    |
rem |   e o coloca no dominio.                                                                                         |
rem +----------------------------------------------------Autor---------------------------------------------------------+
rem | - Wellington           									         	                                           |
rem +----------------------------------------------Sistemas testados---------------------------------------------------+
rem | - Windows 10(x64)		                				 		                                                   |
rem +--------------------------------------------------IMPORTANTE------------------------------------------------------+
rem | - Precisa ser executado com privilégios elevados.								                                   |								               
rem |                                                                                                                  |
rem +-------------------------------------------------CONTRIBUIÇÃO-----------------------------------------------------+
rem | - https://www.profissionaisti.com.br/tutorial-criar-arquivo-bat-com-menu/                                        |
rem | -	https://www.youtube.com/watch?v=FtNzdOKk0kM							                                           |								               
rem +------------------------------------------------------------------------------------------------------------------+



rem ----------------------- Função instalar programas ----------------------------
:menu
cls
echo ==================================
echo *      Instalar programas        *
echo ==================================
echo  1. Usar lista padrao 
echo  2. Usar lista personalizada  
echo  3. Sair                             
echo ==================================

set opInstall=
set /p opInstall=Escolha uma opcao: 

if not defined opInstall goto opcao6

if %opInstall% GTR 3 goto opcao6
if %opInstall% equ 1 set listaProgramas=listaPadrao.txt
if %opInstall% equ 2 set listaProgramas=listaPersonalizada.txt 
if %opInstall% equ 3 goto opcao4 


if not exist "C:\ProgramData\chocolatey" (
	rem Instala o chocolatey
	@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
) else (
	rem Atualiza o chocolatey
	choco upgrade chocolatey
	
	rem Atualiza os pacotes
	choco upgrade all -y
)

rem Acessa a unidade C:\
cd c:\

rem Percorre uma lista com os nomes dos programas a serem instalados
for /F "tokens=*" %%A in (instalarProgBasicos\%listaProgramas%) do (
	rem Instala o programa
	choco install %%A -y
)

rem Instalar em modo silencioso (Ex.: CaminhoCompleto\NomePrograma.extensão /SILENT)
instalarProgBasicos\ProgramasExtras\"setup_64_rev_101.exe" /SILENT 

rem ================================== ATENÇÃO!!! ==============================================
rem 	Se houver algum problema para instalar/baixar o libreoffice usando o "chocolatey", 
rem     descomente a linha abaixo e exclua o "libreoffice-still" da listaPadrao.txt
rem ============================================================================================
rem instalarProgBasicos\ProgramasExtras\"LibreOffice_7.2.7_Win_x64.msi" /passive

instalarProgBasicos\ProgramasExtras\"Instala Simplestec.exe" /SILENT

echo Programas instalados.

rem Adiciona rota
echo Adicionando rota...
route -p ADD 10.96.0.0 MASK 255.255.255.0 10.39.0.2 metric 2
route -p ADD 10.96.0.206 MASK 255.255.255.255 10.39.0.106 metric 1

if %opInstall% equ 3 (
	goto restart
) else (
	pause
	goto menu
)
rem ------------------------------ Fim instalar -------------------------------------


rem ------------------------------ Função reiniciar --------------------------------------
:restart
echo O computador precisa ser reiniciado
pause
shutdown -r -f -t 0
rem -------------------------------- Fim reiniciar ---------------------------------------


rem --------------------------------- Função sair ----------------------------------------
:opcao4
exit /b 0
rem ---------------------------------- Fim sair -------------------------------------------


rem -------------- Função valor inválido para o menu principal ----------------------------
:opcao6
cls
echo ===============================================
echo * Opcao Invalida! Escolha outra opcao do menu *
echo ===============================================
echo.
pause
goto menu
rem ------------------- Fim valor inválido menu principal ---------------------------------
