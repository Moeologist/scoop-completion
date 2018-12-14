# Usage: scoop repair
# Summary: Reinstall failed apps

. "$psscriptroot\..\apps\scoop\current\lib\core.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\manifest.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\buckets.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\versions.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\depends.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\config.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\decompress.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\install.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\shortcuts.ps1"
. "$psscriptroot\..\apps\scoop\current\lib\psmodules.ps1"

reset_aliases

$failed = @()

$true, $false | ForEach-Object { # local and global apps
    $global = $_
    $dir = appsdir $global
    if(!(test-path $dir)) { return }

    Get-ChildItem $dir | Where-Object name -ne 'scoop' | ForEach-Object {
        $app = $_.name
        $status = app_status $app $global
        if($status.failed) {
            $failed += @{ $app = $status.version }
        }
    }
}

if($failed) {
	$architecture = default_architecture
    $failed.keys | ForEach-Object {
        install_app $_ $architecture $False $True $True $True
    }
}

exit 0
