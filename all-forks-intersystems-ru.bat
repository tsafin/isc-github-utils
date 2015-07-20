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
	curl -s -H "Authorization: token %access_token%" https://api.github.com/orgs/%%i/repos?per_page=500 |jq  -c -r ".[] | select(.private<true and .fork>false)| .name, .url, .fork" | sed "N;N;s/\n/;/g" > repolist.%%i.txt

	rem parse all repositories - retrieve parent information
	for /F "tokens=1,2 delims=;" %%j in (repolist.%%i.txt ) do ( 
		echo %%j --- %%k
		curl -s -H "Authorization: token %access_token%" %%k|jq  -c ".| .parent.html_url, \\\"%%j\\\", \\\"%%k\\\" "  >> repolist.1.txt
		sed -e "s/""//g;s/""$//g" repolist.1.txt | sed "N;N;s/\n/;/g"  > repolist.3.txt
	)
)
endlocal