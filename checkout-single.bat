@echo off

set staging=%1
set company=%2
set reponame=%3
set parent=%4
set repo=%5

set subdir=%staging%\%company%\%reponame%

if not exist %subdir mkdir %subdir%
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