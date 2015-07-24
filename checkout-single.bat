@echo off

set staging=%1
set reponame=%2
set parent=%3
set repo=%4

for /F "tokens=2,3 delims=/" %%l in ("%repo%") do (
	set company=%%m
)

set subdir=%staging%\%company%\%reponame%

if not exist %subdir% mkdir %subdir%
pushd %subdir%
echo %company%/%reponame% [ %parent% -^> %repo% ]
if not exist .git (
	git clone %repo% .
	git remote add upstream %parent%
) else (
	git pull origin master
)
git fetch upstream
git checkout master
git merge upstream/master

popd