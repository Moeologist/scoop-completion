# This source code is licensed under the MIT License
# Project URL - https://github.com/Moeologist/scoop-completion
# Thanks to Posh-Git - https://github.com/dahlbyk/posh-git
# Thanks to npm-completion - https://github.com/PowerShell-Completion/npm-completion

# See scoop/lib/core.ps1

@('scoop', 'scoop.cmd', 'scoop.ps1') | ForEach-Object {
	Register-ArgumentCompleter -Native -CommandName $_ -ScriptBlock {
		param($wordToComplete, $commandAst, $cursorPosition)

	# TODO: get installed apps for completions; see npm-completions' completions.ps1
		#function Get-ScoopApps {}
		#
		#if ($commandAst.ToString() -match "scoop(.cmd|.ps1)?\s+(depends|hold|info|install|prefix|reset|search|status|unhold|uninstall|update|virustotal") {
		#	$allScripts = Get-ScoopApps -scriptFilter "$wordToComplete*"
		#	$result=$allScripts | ForEach-Object {
		#		# item1 is the script name, item2 is the script text (passed as tooltip)
		#		[System.Management.Automation.CompletionResult]::new($_.item1, $_.item1, 'ParameterValue', $_.item2)
		#	}
		#
		#	return $result;
		#}

		. $PSScriptRoot\commands.ps1
		$cmds |
			Where-Object { $_ -like "$wordToComplete*" } |
			Sort-Object |
			ForEach-Object {
				[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
			}
	}
}
