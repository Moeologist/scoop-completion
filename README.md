# scoop-completion

presuppositions:
* scoop
* powershell

install via scoop from GitHub:
```powershell
# install
scoop install https://raw.githubusercontent.com/liuzijing97/scoop-completion/master/bucket/scoop-completion.json

# enable completion in current shell
Import-Module scoop-completion

# enable auto-load
if(!(Test-Path $Profile -PathType Leaf)) { New-Item -Force $Profile 1>$null 2>$null }
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"

# (powershell github version) not respect $env:PSModulePath, see below
Import-Module $env:SCOOP/modules/scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module $env:SCOOP/modules/scoop-completion"

# auto update bucket
scoop bucket add scoop-completion https://github.com/liuzijing97/scoop-completion
```


install from PSGallery(**deprecated**):
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"
```

usage (**only support powershell**):
```powershell
Type "scoop [something]" and press Tab key
```

zsh version was in util directory