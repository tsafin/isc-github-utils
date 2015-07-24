@echo off
setlocal
set staging=.git-staging
for /d %%i in (%staging%\*.*) do (
	pushd %%i
	for /d %%j in (*.*) do (
		pushd %%j
		for /f "tokens=* " %%k in ('git status . ^|grep -E "^(Changes|Untracked|Your branch)" ^| grep -E -v up-to-date') do (
			echo %%i\%%j
			echo 	%%k
		)
		popd
	)
	popd
)
endlocal
