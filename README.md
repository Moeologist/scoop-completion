# scoop-auto-completion

presuppositions:
> scoop
> powershell

usage (**only support powershell**):
```powershell
. \path\to\scoop-completion.ps1
Type "scoop [something]" and press Tab key
```

autoload (**exec in powershell**):
```powershell
copy scoop-completion.ps1 $HOME\Documents\WindowsPowerShell\scoop-completion.ps1
echo "`n. `$HOME\Documents\WindowsPowerShell\scoop-completion.ps1" | Out-File -Append -Encoding utf8 $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```
