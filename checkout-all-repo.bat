@echo off
setLocal EnableDelayedExpansion

set staging=.git-staging
@rem clean staging directory first
rem rmdir /s/q %staging%

for /F "tokens=1,2,3 delims=;" %%i in (repolist.3.txt) do ( 
	rem echo %%i --- %%j --- %%k
	for /F "tokens=2,3 delims=/" %%l in ("%%k") do (
		set company=%%m
		echo !company!
		call checkout-single.bat %staging% !company! %%j %%i %%k
	)
)
call git-multi-status.bat
endlocal
