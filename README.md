# scoop-completion

presuppositions:
* scoop
* powershell **(powershell github version not respect $env:PSModulePath)**

install via scoop from GitHub:
```powershell
# add scoop-completion bucket
scoop bucket add scoop-completion https://github.com/liuzijing97/scoop-completion

# install (from added bucket)
scoop install scoop-completion
# or install without a bucket
# scoop install https://raw.githubusercontent.com/liuzijing97/scoop-completion/master/bucket/scoop-completion.json

# enable completion in current shell (pwsh not work, see below)
Import-Module scoop-completion

# enable auto-load, create profile if not exist
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"

--------------------------------------------------------------------------------------------
# powershell github version (aka pwsh or powershell core) does not respect $env:PSModulePath

#enable
if (!(Test-Path -Path "$env:SCOOP")) { $env:SCOOP = "$env:USERPROFILE\scoop" }
Import-Module $env:SCOOP/modules/scoop-completion

#autoload
Add-Content -Path $Profile -Value "`nImport-Module $env:SCOOP/modules/scoop-completion"
```


install from PSGallery(**deprecated**):
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"
```

usage:
```powershell
Type "scoop [something]" and press Tab key
```

zsh version was in util directory
