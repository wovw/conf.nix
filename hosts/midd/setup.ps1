<#
.SYNOPSIS
    Standalone Windows Bootstrap
    Handles: Prereqs, SSH Keygen, GitHub Clone, Scoop apps, VS Tools, and Rust.
#>

$ErrorActionPreference = "Stop"

# --- Self-Elevation ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ":: Elevation required. Restarting as Admin..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host ":: Starting Windows Setup..." -ForegroundColor Cyan

# --- Get email ---
$gitEmail = Read-Host ":: Enter your email for Git and SSH"
if ([string]::IsNullOrWhiteSpace($gitEmail)) {
    Write-Error "Email is required for setup. Exiting."
    exit 1
}

# --- System Prerequisites ---

# VBScript Check (for tauri)
Write-Host ":: Checking VBScript Capability..." -ForegroundColor Green
try {
    $vbsCap = Get-WindowsCapability -Online -Name "VBSCRIPT~~~~" -ErrorAction Stop
    if ($vbsCap.State -ne "Installed") {
        Write-Host "   -> Installing VBScript..."
        $result = DISM /Online /Add-Capability /CapabilityName:VBSCRIPT~~~~
        if ($LASTEXITCODE -ne 0) { throw "DISM failed to install VBScript." }
    } else {
        Write-Host "   -> VBScript already installed." -ForegroundColor DarkGray
    }
} catch {
    Write-Host "!! CRITICAL ERROR: VBScript is missing and cannot be installed. !!" -ForegroundColor Red
    Write-Host "   This often happens on modified Windows ISOs (Tiny11, AtlasOS)."
    Write-Host "   Some legacy tools may fail."
    $response = Read-Host "   Do you want to continue anyway? (y/n)"
    if ($response -ne 'y') { exit 1 }
}

# Developer Mode
Write-Host ":: Enabling Developer Mode..." -ForegroundColor Green
$devModePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not (Test-Path $devModePath)) { New-Item -Path $devModePath -Force | Out-Null }
Set-ItemProperty -Path $devModePath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord
Write-Host "   -> Developer Mode Enabled." -ForegroundColor DarkGray

# Execution Policy (allow user / scoop / other to run scripts)
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
} catch {
    # Ignore "overridden" errors, as they mean success for the registry change
    if ($_.Exception.Message -like "*overridden*") {
        Write-Host "   -> Execution Policy set (effective next session)." -ForegroundColor DarkGray
    } else {
        Write-Warning "Could not set Execution Policy: $($_.Exception.Message)"
    }
}

# --- Windows Preferences & Cleanup ---
Write-Host ":: Applying Windows Preferences..." -ForegroundColor Green

# Activation
Write-Host ":: Running Microsoft Activation Scripts (HWID)..." -ForegroundColor Green
try {
    & ([ScriptBlock]::Create((irm https://get.activated.win))) /hwid
    Write-Host "   -> Activation routine complete." -ForegroundColor DarkGray
} catch {
    Write-Warning "Failed to run activation script!"
}

# Dark Mode
$themeKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (-not (Test-Path $themeKey)) { New-Item -Path $themeKey -Force | Out-Null }
Set-ItemProperty -Path $themeKey -Name "SystemUsesLightTheme" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $themeKey -Name "AppsUseLightTheme" -Value 0 -Type DWord -Force
Write-Host "   -> Dark Mode enabled." -ForegroundColor DarkGray

# Disable Annoyances (Tips, Tricks, Welcome Experience, Suggested Apps)
$contentKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
if (-not (Test-Path $contentKey)) { New-Item -Path $contentKey -Force | Out-Null }
Set-ItemProperty -Path $contentKey -Name "SubscribedContent-338387Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $contentKey -Name "SubscribedContent-310093Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $contentKey -Name "SystemPaneSuggestionsEnabled" -Value 0 -Type DWord -Force
Write-Host "   -> Windows tips/ads/suggestions disabled." -ForegroundColor DarkGray

# Disable OneDrive
Write-Host ":: Disabling OneDrive..." -ForegroundColor Green
Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
$odPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
if (-not (Test-Path $odPolicyKey)) { New-Item -Path $odPolicyKey -Force | Out-Null }
Set-ItemProperty -Path $odPolicyKey -Name "DisableFileSyncNGSC" -Value 1 -Type DWord -Force
$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Remove-ItemProperty -Path $runKey -Name "OneDrive" -ErrorAction SilentlyContinue
Write-Host "   -> OneDrive disabled via Group Policy registry key." -ForegroundColor DarkGray

# --- Package Management (Scoop & Winget) ---

# Scoop Bootstrap
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host ":: Installing Scoop..." -ForegroundColor Cyan
    & ([ScriptBlock]::Create((irm get.scoop.sh))) -RunAsAdmin
} else {
    Write-Host ":: Updating Scoop..." -ForegroundColor DarkGray
    scoop update
}

# Install git first (required for scoop buckets)
scoop install git

# Scoop Buckets
$buckets = @("extras", "nerd-fonts", "versions") 
$currentBuckets = scoop bucket list
foreach ($bucket in $buckets) {
    if ($currentBuckets -notmatch $bucket) {
        scoop bucket add $bucket
    }
}

# Scoop Packages
$scoopPackages = @(
    "pwsh", "llvm", "sccache", "cmake", "rustup",
    "azure-cli", "flatc", "JetBrainsMono-NF", "cursor-latest"
)

Write-Host ":: Installing Scoop Packages..." -ForegroundColor Green
foreach ($pkg in $scoopPackages) {
    if (-not (scoop list $pkg)) {
        Write-Host "   -> Installing $pkg"
        scoop install $pkg
    }
}

# VS Build Tools (Winget)
Write-Host ":: Checking Visual Studio Build Tools..." -ForegroundColor Green
$vsInfo = winget list --id Microsoft.VisualStudio.BuildTools --source winget | Out-String
if ($vsInfo -notmatch "Microsoft.VisualStudio.BuildTools") {
    Write-Host "   -> Installing VS Build Tools (C++ desktop dev enabled)..."

    $args = "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --passive --wait"
    winget install --id Microsoft.VisualStudio.2022.BuildTools --source winget --force --override $args

    # Double-Check: Wait for the installer process to actually disappear
    # (Sometimes winget returns early even with --wait)
    Write-Host "   -> Verifying installation completion..." -NoNewline
    while (Get-Process "vs_installer" -ErrorAction SilentlyContinue) {
        Start-Sleep -Seconds 5
        Write-Host "." -NoNewline
    }
    Write-Host " Done."
} else {
    Write-Host "   -> VS Build Tools appear to be installed." -ForegroundColor DarkGray
}

# --- Update env ---

# update PATH just for script
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# permanently set RUSTC_WRAPPER to sccache for user
# We check 'scoop list' as a fallback because Get-Command can sometimes be stale in the same session
if ((Get-Command sccache -ErrorAction SilentlyContinue) -or (scoop list sccache)) {
    if ([System.Environment]::GetEnvironmentVariable('RUSTC_WRAPPER', 'User') -ne 'sccache') {
        Write-Host "   -> Setting RUSTC_WRAPPER to sccache (User scope)..."
        [System.Environment]::SetEnvironmentVariable('RUSTC_WRAPPER', 'sccache', 'User')
    }
    $env:RUSTC_WRAPPER = 'sccache' 
} else {
    Write-Warning "sccache command not found! RUSTC_WRAPPER was NOT set."
}

# --- SSH & Git Configuration ---

Write-Host ":: Configuring SSH..." -ForegroundColor Green

# Ensure SSH Agent is running
$sshAgent = Get-Service -Name ssh-agent
if ($sshAgent.StartType -ne 'Automatic') { Set-Service -Name ssh-agent -StartupType Automatic }
if ($sshAgent.Status -ne 'Running') { Start-Service ssh-agent }

# Generate Key if missing
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir -Force | Out-Null }

$sshKeyFile = "$sshDir\id_ed25519"
if (-not (Test-Path $sshKeyFile)) {
    Write-Host "   -> Generating new SSH Key for $gitEmail..."
    ssh-keygen -t ed25519 -C $gitEmail -f $sshKeyFile -N '""'
}

# Add to Agent
if (Test-Path $sshKeyFile) {
    # ssh-add writes success messages to stderr
    # We temporarily change the error policy for this specific command.
    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    ssh-add $sshKeyFile
    $ErrorActionPreference = $oldEAP
}

# Git Config
Write-Host ":: Configuring Git..." -ForegroundColor Green
git config --global user.email $gitEmail
git config --global core.autocrlf input

# Clone conf.nix
$repoPath = "$env:USERPROFILE\conf.nix"
if (-not (Test-Path $repoPath)) {
    # Copy pubkey to Clipboard and Prompt
    if (Test-Path "$sshKeyFile.pub") {
        $pubKey = Get-Content "$sshKeyFile.pub"
        $pubKey | Set-Clipboard
        Write-Host "`n------------------------------------------------------------" -ForegroundColor Yellow
        Write-Host "PUBLIC KEY COPIED TO CLIPBOARD" -ForegroundColor Yellow
        Write-Host "1. Go to https://github.com/settings/ssh/new"
        Write-Host "2. Paste the key and save."
        Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
        
        Pause ":: Press Enter once you have added the key to GitHub..."
    }

    Write-Host ":: Cloning conf.nix repo..." -ForegroundColor Green
    try {
        git clone --quiet git@github.com:wovw/conf.nix.git $repoPath
    } catch {
        Write-Error "Failed to clone repository. Did you add the SSH key to GitHub?"
        exit 1
    }
} else {
    Write-Host ":: Repo already exists at $repoPath" -ForegroundColor DarkGray
}

# --- Rust Setup ---
Write-Host ":: Setting up Rust (MSVC)..." -ForegroundColor Green

if (Get-Command rustup -ErrorAction SilentlyContinue) {
    rustup default nightly

    function Install-Crate ($CrateName, $BinaryName) {
        if (Get-Command $BinaryName -ErrorAction SilentlyContinue) {
            Write-Host "   -> $BinaryName already installed." -ForegroundColor DarkGray
        } else {
            Write-Host "   -> Installing $CrateName..."
            cargo install $CrateName
        }
    }
    Install-Crate "tree-sitter-cli" "tree-sitter"
    Install-Crate "trusted-signing-cli" "trusted-signing-cli"
} else {
    Write-Warning "Rustup command not found! Skipping Rust configuration and tool installation."
}

Write-Host "`n:: SETUP COMPLETE! ::" -ForegroundColor Cyan
Write-Host "Please reboot to ensure all changes (especially Path vars) take effect." -ForegroundColor Gray
Start-Sleep -Seconds 3
