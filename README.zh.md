# scoop 自动补全

[English](https://github.com/liuzijing97/scoop-completion/blob/master/README.md)

依赖:
* scoop
* PowerShell **(或 PowerShell Core)**

通过 scoop 安装:
```powershell

# add auto-update bucket
scoop bucket add scoop-completion https://github.com/liuzijing97/scoop-completion

# install
scoop install scoop-completion
```

在当前 shell 启用补全并启用自动加载
```powershell
# check scoop installation
if (!(Test-Path -Path "$env:SCOOP")) { $env:SCOOP = "$env:USERPROFILE\scoop" }

# enable completion in current shell
Import-Module "$env:SCOOP/modules/scoop-completion"

# enable auto-load
Add-Content -Path $Profile -Value "`nImport-Module `"$env:SCOOP/modules/scoop-completion`""
```


通过 PSGallery 安装 **(已弃用)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
Add-Content -Path $Profile -Value "`nImport-Module scoop-completion"
```

用法:
```powershell
输入 "scoop [任何命令]" 然后按 Tab 键
```

zsh 版补全在 /zsh 文件夹