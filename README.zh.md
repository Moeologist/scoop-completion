## scoop 自动补全

[English](https://github.com/Moeologist/scoop-completion/blob/master/README.md)

---

**注意!!!**

如果控制台输出
```powershell
Get-Content : Cannot find path 'D:\scoop\shims\scoop-IsReadOnly.ps1' because it does not exist.
At D:\scoop\apps\scoop\current\lib\commands.ps1:22 char:19
...
...
```
阅读 [scoop issure 3528](https://github.com/lukesampson/scoop/issues/3528). 简单来说，事先运行
```powershell
scoop config alias @{}
```

---

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
在文本编辑器打开 $profile，然后添加启用代码（Import-Module 行）到该文件。

---

用法:
输入 "scoop [想补全的内容]" 然后按 Tab 键将循环补全项，Ctrl+Space 将触发菜单式的补全

例子:
```powershell
scoop ins[Press Tab]
scoop install py[Press Ctrl+Space]
scoop uninstall [Press Ctrl+Space]

```

---

卸载:
```powershell
scoop uninstall scoop-completion
scoop bucket rm scoop-completion
```
然后手动修改 $Profile (移除启用代码)

---

通过 PSGallery 安装 **(已弃用)**:
```powershell
Install-Module -AllowClobber -Name scoop-completion -Scope CurrentUser
Import-Module scoop-completion
```
