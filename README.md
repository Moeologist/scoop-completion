# scoop-completion

[中文](https://github.com/Moeologist/scoop-completion/blob/master/README.zh.md)

---

Presuppositions:
* [scoop](https://github.com/lukesampson/scoop)
* [PowerShell 5](https://aka.ms/wmf5download) (or later, include [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-6))

Install via scoop:
```powershell
# add auto-update bucket
scoop bucket add scoop-completion https://github.com/Moeologist/scoop-completion

# install
scoop install scoop-completion
```

Enable completion in current shell:
```powershell
# enable completion in current shell, use absolute path because PowerShell Core not respect $env:PSModulePath
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"
```

Auto-load, please modify $Profile manually. If you want completion to work for allusers | allhosts, read [Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6#the-profile-variable)
```powershell
# create profile if not exist
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }

# print $profile path
$profile
```
Open $profile in your text editor, and put the enable code (Import-Module line) into this file.

---

Usage:
Type "scoop [something]" and press Tab key will cycle completion items, Ctrl+Space will trigger menu-completion.

Example:
```powershell
scoop ins[Press Tab]
scoop install py[Press Ctrl+Space]
scoop uninstall [Press Ctrl+Space]
```

---

Uninstall:
```powershell
scoop uninstall scoop-completion
```
Then, modify $Profile to remove initialization calls

---

---

Install from PSGallery **(deprecated)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
```
