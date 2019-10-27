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

enable completion in current shell and auto-load
```powershell
# check scoop installation
if (!(Test-Path -Path "$env:SCOOP")) { $env:SCOOP = "$env:USERPROFILE\scoop" }

# enable completion in current shell
Import-Module "$env:SCOOP/modules/scoop-completion"

# enable auto-load
Add-Content -Path $Profile -Value "`nImport-Module `"$env:SCOOP/modules/scoop-completion`""
```


install from PSGallery **(deprecated)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"
```

usage:
```powershell
Type "scoop [something]" and press Tab key
```

zsh completion was in /zsh directory