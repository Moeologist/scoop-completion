# scoop-auto-completion

presuppositions:
* scoop
* powershell

install from PSGallery:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion" 
```

usage (**only support powershell**):
```powershell
Type "scoop [something]" and press Tab key
```
