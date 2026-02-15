@echo off
REM This script does two main things:
REM
REM 1. If run in a location containing the .github folder, it commits its contents to the chosen repo.
REM 2. It deletes selected labels and creates new ones.
REM
REM The first part can be achieved by cloning a template repository.
REM The second is trickier, since template repositories do not include label data.
REM
REM Very useful for me, probably not very useful for you.
REM
REM Install GitHub CLI first (winget install GitHub.cli or brew install gh).
REM Then authenticate with your account (gh auth login).
REM Set DATA= and labels_to_delete.txt as needed.
REM
REM Run this script via: INITIALIZE user/repo
REM
REM Visit https://ninergames.com/ or spread the word if you want to say “thank you”. Thank you.

setlocal enabledelayedexpansion

REM === CHECK INPUT ===

if "%~1"=="" (
    echo Usage: initialize-repository owner/repo
    exit /b 1
)

set NEXT=8
set REPO=%~1
set TEMPLATE_DIR=%cd%\.github
set "DATA=api|5319e7|API design, endpoints, contracts, and integrations with external services;assets|e4e669|Static assets, data extracted from sources, or other non-code resources;code|00f4a1|Refactoring, logic changes, performance improvements, and other code-only tasks;data|59c442|Database schema, models, migrations, relations, and data-layer logic;documentation|e4e669|Analysis docs, README files, wiki content, and all project documentation;i18n|9a0c25|Localization, translations, language handling, and internationalization issues;ux|cfd3d7|User experience, interface design, usability improvements, and visual layout"

REM === TEMPORARY ENVIRONMENT ===

echo.
echo === Processing repository: %REPO% ===
echo.

echo 1. Creating temporary files and folders.

set WORKDIR=%cd%\tmp
if not exist "%WORKDIR%" mkdir "%WORKDIR%"

> "%TEMP%\labels_to_delete.txt" (
    echo bug
    echo feature
    echo invalid
    echo wontfix
    echo question
    echo duplicate
    echo enhancement
    echo help wanted
    echo good first issue
    echo invalid or wontfix
    echo github-actions
    echo dependencies
    echo javascript
    echo security
    echo dotnet
    echo python
    echo ruby
    echo rust
    echo php
    echo go
)

echo 2. Removing unnecessary issue labels:

for /f "usebackq delims=" %%L in (`gh label list --repo=%REPO% --json name -q ".[].name"`) do (
    findstr /i /x /c:"%%~L" "%TEMP%\labels_to_delete.txt" >nul
    if not errorlevel 1 (
        gh label delete "%%L" --repo %REPO% --yes >nul 2>&1
        echo    - removed label %%L...
    )
)

echo 3. Synchronizing repository labels:

for %%B in ("%DATA:;=" "%") do (

    set "block=%%~B"

    for /f "tokens=1-3 delims=|" %%A in ("!block!") do (
        gh label create "%%A" --color %%B --description "%%C" --repo %REPO% >nul 2>&1
        if errorlevel 1 (
            gh label edit "%%A" --color %%B --description "%%C" --repo %REPO% >nul 2>&1
            echo    - updated existing label: %%A
        ) else (
            echo    - created new label: %%A
        )
    )
)

if exist "%TEMPLATE_DIR%" (
    echo 4. Cloning remote repository.

    gh repo clone %REPO% "%WORKDIR%\%REPO%" >nul 2>&1
    
    if errorlevel 1 (
        echo X. Failed to clone %REPO%.
        
        set NEXT=5
        goto finish
    )

    echo 5. Applying initial template.

    cd "%WORKDIR%\%REPO%"
    xcopy "%TEMPLATE_DIR%" ".github" /E /Y >nul

    echo 6. Commiting changes.

    git add . >nul
    git diff --cached --quiet
    if errorlevel 1 (
        echo 7. Pushing changes to remote repository.
        
        git commit -m "Apply global .github template" >nul
        git push --quiet >nul 2>&1        
    ) else (
        echo 7. No changes to commit this time.
    )
) else (
    echo 4. No .github folder found. Skipping configuration and workflows part.
    set NEXT=5
)

:finish

cd "%WORKDIR%"

echo %NEXT%. Cleaning up temporary files and folders.

if exist "%WORKDIR%\%REPO%" rmdir /s /q "%WORKDIR%\%REPO%"
del "%TEMP%\labels_to_delete.txt" >nul 2>&1

echo.
echo === Processed repository: %REPO% ===