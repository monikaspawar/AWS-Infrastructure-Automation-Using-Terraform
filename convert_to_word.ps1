# PowerShell script to convert Markdown to Word document
# Requires pandoc to be installed

param(
    [string]$InputFile = "AWS_Infrastructure_Documentation.md",
    [string]$OutputFile = "AWS_Infrastructure_Documentation.docx"
)

# Check if pandoc is installed
try {
    $pandocVersion = pandoc --version
    Write-Host "Pandoc found: $($pandocVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "Pandoc not found. Please install pandoc first:" -ForegroundColor Red
    Write-Host "Download from: https://pandoc.org/installing.html" -ForegroundColor Yellow
    Write-Host "Or use chocolatey: choco install pandoc" -ForegroundColor Yellow
    exit 1
}

# Convert Markdown to Word
try {
    Write-Host "Converting $InputFile to $OutputFile..." -ForegroundColor Blue
    pandoc $InputFile -o $OutputFile --reference-doc=template.docx 2>$null
    
    if (Test-Path $OutputFile) {
        Write-Host "Successfully created $OutputFile" -ForegroundColor Green
        Write-Host "File location: $(Resolve-Path $OutputFile)" -ForegroundColor Cyan
    } else {
        # Fallback without template
        pandoc $InputFile -o $OutputFile
        Write-Host "Created $OutputFile (without custom template)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error converting file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nConversion completed successfully!" -ForegroundColor Green