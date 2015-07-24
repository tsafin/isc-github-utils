@echo off
setLocal EnableDelayedExpansion
del /Q repolist.txt repolist.intersystems*.txt repolist.1.txt repolist.3.txt 2>&1 > NUL
set repo=intersystems-ru
call .access_token.bat
rem curl -I -H "Authorization: token OAUTH-TOKEN" https://api.github.com/orgs/intersystems-ru/repos?per_page=500
for %%i in (intersystems-ru,intersystems) do (
	echo.
	echo Processing %%i forks
	echo.
	curl -s -H "Authorization: token %access_token%" https://api.github.com/orgs/%%i/repos?per_page=500 |jq  -c -r ".[] | select(.private<true and .fork>false)| .name, .url, .html_url, .fork" | sed "N;N;N;s/\n/;/g" > repolist.%%i.txt

	rem parse all repositories - retrieve parent information
	for /F "tokens=1,2,3 delims=;" %%j in (repolist.%%i.txt ) do ( 
		echo %%j --- %%k
		curl -s -H "Authorization: token %access_token%" %%k|jq  -c ".| .parent.html_url, \\\"%%j\\\", \\\"%%l\\\" "  >> repolist.1.txt
		sed -e "s/""//g;s/""$//g" repolist.1.txt | sed "N;N;s/\n/;/g"  > repolist.3.txt
	)
)

set staging=.git-staging
@rem clean staging directory first
rem rmdir /s/q %staging%

rem checkout (clone if there is empty staging area, or update if there is something) all forks mentioned in repolist.3.txt

for /F "tokens=1,2,3 delims=;" %%i in (repolist.3.txt) do ( 
	rem echo %%i --- %%j --- %%k
	for /F "tokens=2,3 delims=/" %%l in ("%%k") do (
		set company=%%m
		call checkout-single.bat %staging% !company! %%j %%i %%k
	)
)

call git-multi-status.bat
echo Please review the status before proceeding further, or interrupt script via Ctrl+C
pause
for /d %%i in (%staging%\*.*) do (
	pushd %%i
	for /d %%j in (*.*) do (
		pushd %%j
		for /f "tokens=* " %%k in ('git status . ^|grep -E "^(Changes|Untracked|Your branch)" ^| grep -E -v up-to-date') do (
			echo %%i\%%j
			echo 	%%k
			git push origin master
		)
		popd
	)
	popd
)

endlocal