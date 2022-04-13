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


rem ---------------------------------- Menu -------------------------------------
:menu
cls
echo =======================================
echo            MENU TAREFAS
echo =======================================
echo  1. Instalar os programas
rem echo  2. Renomear o PC e coloca-lo no Dominio
echo  2. Configurar a rede
echo  3. Executar 1 e 2              
echo  4. Sair                        
echo =======================================

set opMenu=
set /p opMenu=Escolha uma opcao: 

if not defined opMenu goto opcao5

if %opMenu% equ 1 goto opcao1
if %opMenu% equ 2 goto opcao2
if %opMenu% equ 3 goto opcao3
if %opMenu% equ 4 goto opcao4
if %opMenu% GEQ 5 goto opcao5
rem ----------------------------- Fim Menu ---------------------------------------


rem ----------------------- Função instalar programas ----------------------------
:opcao1
cls
echo ==================================
echo *      Instalar programas        *
echo ==================================
echo  1. Usar lista padrao 
echo  2. Usar lista personalizada  
echo  3. Voltar a tela principal                              
echo ==================================

set opInstall=
set /p opInstall=Escolha uma opcao: 

if not defined opInstall goto opcao6

if %opInstall% GTR 3 goto opcao6
if %opInstall% equ 1 set listaProgramas=listaPadrao.txt
if %opInstall% equ 2 set listaProgramas=listaPersonalizada.txt 
if %opInstall% equ 3 goto menu 


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
instalarProgBasicos\ProgramasExtras\"LibreOffice_7.2.6_Win_x64.msi" /passive
instalarProgBasicos\ProgramasExtras\"Instala Simplestec.exe" /SILENT

echo Programas instalados.

rem Adiciona rota
echo Adicionando rota...
route -p ADD 10.96.0.0 MASK 255.255.255.0 10.39.0.2 metric 2
route -p ADD 10.96.0.206 MASK 255.255.255.255 10.39.0.106 metric 1

if %opMenu% equ 3 (
	goto restart
) else (
	pause
	goto menu
)
rem ------------------------------ Fim instalar -------------------------------------


rem --------------------------- Função Configurar -----------------------------------
:opcao2
cls
echo ===========================================
echo *          Configurar a rede              *
echo ===========================================

rem set /p novoNomePC="Informe o novo nome do Computador: " 
rem set /p interface="Interface: " || set "interface=Ethernet"
set /p ip="Endereco IP: "
set /p mask="Mascara de rede: "
set /p gateway="Gateway: "
set /p dns="DNS: "
rem set /p dominio="Dominio: "

rem Configura IP, Mascara e o Gateway
netsh interface ip set address name="Ethernet" static %ip% %mask% %gateway%

rem 'netsh' executou com erro?
if %errorlevel% neq 0 (
	echo Erro ao configurar parametros da rede
	pause
	goto menu
)

rem Configura o DNS primario
netsh interface ip set dnsservers name="Ethernet" static %dns%

rem 'netsh' executou com erro?
if %errorlevel% neq 0 (
	echo Erro ao configurar o DNS
	pause
	goto menu
)

rem Renomeia o computador e o coloca do dominio
rem powershell.exe Add-Computer -DomainName %dominio% -NewName %novoNomePC%

rem 'powershell.exe' executou com erro?
rem if %errorlevel% neq 0 (
rem	echo Erro ao renomear/colocar no dominio
rem 	pause
rem goto menu
rem )

echo Adicionando rota...           
route delete 10.96.0.0
route -p ADD 10.96.0.0 MASK 255.255.255.0 10.39.0.2 metric 2
route -p ADD 10.96.0.206 MASK 255.255.255.255 10.39.0.106 metric 1
echo Rota adicionada.  

if %opMenu% equ 3 (goto opcao1) else (goto restart)
rem ------------------------------ Fim Configurar ----------------------------------------


rem ------------------------------- Opções 1 e 2 ---------------------------------------
:opcao3
cls
echo ==================================
echo *  Executando os passos 1 e 2... *
echo ==================================
goto :opcao2
rem --------------------------------- Fim opções ----------------------------------------


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
:opcao5
cls
echo ===============================================
echo * Opcao Invalida! Escolha outra opcao do menu *
echo ===============================================
echo.
pause
goto menu
rem ------------------- Fim valor inválido menu principal ---------------------------------


rem ----------------- Função valor inválido menu instalação--------------------------------
:opcao6
cls
echo ===============================================
echo *   Opcao Invalida! Escolha uma das listas    *
echo ===============================================
echo.
pause
goto opcao1
rem ------------------ Fim valor inválido menu instalação ---------------------------------