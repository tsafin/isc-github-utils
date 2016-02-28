@echo off
setLocal EnableDelayedExpansion
pushd .git-staging
for %%i in (intersystems,intersystems-ru) do (
  pushd %%i
  for /D %%j in (*) do (
    pushd %%j
    rem git log --oneline -n1 | findstr "merge remote-tracking" > nul
    echo %%i\%%j:
    git log --branches --not --remotes=upstream --oneline
    popd
  )
  popd
)
popd