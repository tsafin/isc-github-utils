@echo off
del /Q repolist.txt  > NUL
del /Q repolist.1.txt> NUL
set repo=intersystems-ru
echo Processing %repo% forks

rem curl https://api.github.com/orgs/intersystems-ru/repos?per_page=500|jq ".[] | {name,html_url,fork}|select(.fork > false)"
curl -s https://api.github.com/orgs/intersystems-ru/repos?per_page=500|jq  -c -r ".[] | select(.fork > false)| .name, .url" | sed "N;s/\n/;/" > repolist.txt

rem parse all repositories - retrieve parent information
for /F "tokens=1,* delims=;" %%i in (repolist.txt ) do ( 
	echo %%i --- %%j
	rem curl -s %%j|jq  -c ".| .parent.html_url, \\\"%%i\\\", \\\"%%j\\\" "  | sed "N;N;s/\n/;/g" >> repolist.1.txt
	curl -s %%j|jq  -c ".| .parent.html_url, \\\"%%i\\\", \\\"%%j\\\" "  >> repolist.1.txt
)
