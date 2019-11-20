# scoop 自动补全

[English](https://github.com/Moeologist/scoop-completion/blob/master/README.md)

依赖:
* scoop
* PowerShell **(或 PowerShell Core)**

通过 scoop 安装:
```powershell

# add auto-update bucket
scoop bucket add scoop-completion https://github.com/Moeologist/scoop-completion

# install
scoop install scoop-completion
```

在当前 shell 启用补全并启用自动加载，
如果使用
$profile.CurrentUserAllHosts | $profile.AllUsersCurrentHost | $profile.AllUsersAllHosts
替代 $profile，
scoop-completion 将为 其他Host | 其他用户 | 两者工作
[Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6#the-profile-variable)
```powershell
# get scoop installation
$scoopdir = $(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName

# enable completion in current shell
Import-Module "$scoopdir\modules\scoop-completion"

# create profile if not exist
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }

# enable auto-load
Add-Content -Path $profile -Value "`nImport-Module `"$scoopdir\modules\scoop-completion`""
```


通过 PSGallery 安装 **(已弃用)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }
Add-Content -Path $profile -Value "`nImport-Module scoop-completion"
```

用法:

输入 "scoop [想补全的单词]" 然后按 Tab 键
