@echo off

dir c:\users /b > c:\windows\temp\users.txt

if not exist "c:\RH_PMJP" (
	mkdir "c:\RH_PMJP"
)
copy /y \\IP_SERVER\sistemas\RH\RH_PMJP.exe c:\RH_PMJP\RH_PMJP.exe
	
for /F "tokens=*" %%A in (c:\windows\temp\users.txt) do (
	if exist "c:\users\%%A\Desktop\RH_PMJP" (
		(del "c:\users\%%A\Desktop\RH_PMJP") && (MKLINK "c:\users\%%A\Desktop\RH_PMJP" "c:\RH_PMJP\RH_PMJP.exe")
	) else (
		MKLINK "c:\users\%%A\Desktop\RH_PMJP" "c:\RH_PMJP\RH_PMJP.exe"
	)
)
exit /b 0
