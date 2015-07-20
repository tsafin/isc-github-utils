@echo off
call .access_token.bat

echo number of public forks for %1 repository
curl -s -H "Authorization: token %access_token%" https://api.github.com/orgs/%1/repos?per_page=500  | jq  -c -r ".[] | select(.private!=true and .fork!=false) | .name " | wc -l