@echo off
pushd .git-staging
for %%i in (intersystems,intersystems-ru) do (
  pushd %%i
  for /D %%j in (*) do (
    pushd %%j
    git log --oneline -n1 | findstr "merge remote-tracking" > nul
    if not errorlevel 1 (
      echo %%i\%%j
      rem rmdir /s/q .
    )
    popd
  )
  popd
)
popd