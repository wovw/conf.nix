$ErrorActionPreference = "Stop"

function New-Symlink ($Source, $Target) {
    if (Test-Path $Target) {
        Write-Host "  -> Removing existing: $Target" -ForegroundColor Yellow
        Remove-Item $Target -Force
    }
    # Create parent directory if it doesn't exist (e.g. for .config nesting)
    $parent = Split-Path $Target -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent | Out-Null }
    
    New-Item -ItemType SymbolicLink -Path $Target -Value $Source | Out-Null
    Write-Host "  -> Linked $Source to $Target" -ForegroundColor Cyan
}

winget configure .\hosts\midd\winget.dsc.yaml --accept-configuration-agreements

New-Symlink -Source (Resolve-Path ".\hosts\midd\.cargo\config.toml") -Target "$env:USERPROFILE\.cargo\config.toml"

# --- Rust Setup ---
Write-Host ":: Setting up Rust (MSVC)..." -ForegroundColor Green
rustup default nightly-msvc
cargo install tree-sitter-cli
cargo install trusted-signing-cli

Write-Host ":: Setup Complete! Please reboot." -ForegroundColor Cyan
