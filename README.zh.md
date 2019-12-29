# scoop 自动补全

[English](https://github.com/Moeologist/scoop-completion/blob/master/README.md)

依赖:
* [scoop](https://github.com/lukesampson/scoop)
* [PowerShell 5](https://aka.ms/wmf5download) (或更新，包括 [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-6))

通过 scoop 安装:
```powershell
# add auto-update bucket
scoop bucket add scoop-completion https://github.com/Moeologist/scoop-completion

# install
scoop install scoop-completion
```

在当前 shell 启用补全:
```powershell
# enable completion in current shell
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
```

自动加载，请手动修改 $Profile。如果希望补全为 所有用户 | 所有host 工作，请阅读 [Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6#the-profile-variable)
```powershell
# create profile if not exist
if (!(Test-Path $profile)) { New-Item -Path $profile -ItemType "file" -Force }

# print $profile path
$profile
```
在文本编辑器打开 $profile，然后添加启用代码（Import-Module 行）到该文件，为了避免不必要的错误提示，可以将其置入 try 块中。
```powershell
try { Import-Module -ErrorAction Stop "$($(Get-Item $(Get-Command -ErrorAction Stop scoop).Path).Directory.Parent.FullName)\modules\scoop-completion" } catch {}
```

用法:
输入 "scoop [想补全的单词]" 然后按 Tab 键，Ctrl+Space 将触发菜单式的补全

---

通过 PSGallery 安装 **(已弃用)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
```
