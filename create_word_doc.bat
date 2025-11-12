@echo off
echo Converting Markdown to Word Document...
echo.

REM Check if pandoc is available
pandoc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Pandoc not found!
    echo Please install pandoc from: https://pandoc.org/installing.html
    echo Or use chocolatey: choco install pandoc
    pause
    exit /b 1
)

REM Convert the markdown file to Word
pandoc AWS_Infrastructure_Documentation.md -o AWS_Infrastructure_Documentation.docx

if exist "AWS_Infrastructure_Documentation.docx" (
    echo SUCCESS: Word document created successfully!
    echo File: AWS_Infrastructure_Documentation.docx
    echo.
    echo Opening the document...
    start AWS_Infrastructure_Documentation.docx
) else (
    echo ERROR: Failed to create Word document
)

pause