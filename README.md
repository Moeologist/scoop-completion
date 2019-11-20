# scoop-completion

[中文](https://github.com/Moeologist/scoop-completion/blob/master/README.zh.md)

presuppositions:
* scoop
* PowerShell **(or PowerShell Core)**

install via scoop:
```powershell

# add auto-update bucket
scoop bucket add scoop-completion https://github.com/Moeologist/scoop-completion

# install
scoop install scoop-completion
```

enable completion in current shell and auto-load,
use
$profile.CurrentUserAllHosts|$profile.AllUsersCurrentHost|$profile.AllUsersAllHosts
instead of $profile,
scoop-completion will work for allhosts|allusers|both
```powershell
# get scoop installation
$scoopdir = $(Get-Command scoop).Path, $env:SCOOP, "$env:USERPROFILE\scoop" | Select-Object -first 1

# enable completion in current shell
Import-Module "$scoopdir\modules\scoop-completion"

# create profile if not exist
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }

# enable auto-load
Add-Content -Path $profile -Value "`nImport-Module `"$scoopdir\modules\scoop-completion`""
```


install from PSGallery **(deprecated)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }
Add-Content -Path $profile -Value "`nImport-Module scoop-completion"
```

usage:

Type "scoop [something]" and press Tab key
