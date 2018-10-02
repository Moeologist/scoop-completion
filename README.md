# scoop-auto-completion

presuppositions:
> scoop

usage:
```
. /path/to/scoop-completion.ps1
```

autoload (**exec in powershell**):
```powershell
mv scoop-completion.ps1 $env:USERDOMAIN\WindowsPowerShell
echo '. $HOME\Documents\WindowsPowerShell\scoop-completion.ps1' | Out-File -Append $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```