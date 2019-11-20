# This source code is licensed under the MIT License
# Project URL - https://github.com/Moeologist/scoop-completion
# Thanks to Posh-Git - https://github.com/dahlbyk/posh-git

$scoopdir = $env:SCOOP, "$env:USERPROFILE\scoop" | Select-Object -first 1

if (!(Test-Path -Path "$scoopdir")) { Write-Warning 'no scoop installed' }

if ( -not (Get-Variable ScoopCompletionUseLocalData -Scope Global -ErrorAction SilentlyContinue)) {
	$global:ScoopCompletionUseLocalData = $true
	$global:ScoopCompletionUseWordMatch = $false
}

$script:ScoopCommands = @('alias', 'bucket', 'cache', 'checkup', 'cleanup', 'config', 'create', 'depends', 'export', 'help', 'hold', 'home',
	'info', 'install', 'list', 'prefix', 'reset', 'search', 'status', 'unhold', 'uninstall', 'update', 'virustotal', 'which')

$script:ScoopSubcommands = @{
	alias  = 'add list rm'
	bucket = 'add list known rm'
	cache  = 'rm show'
	config = 'rm'
}

$script:ScoopShortParams = @{
	install    = 'g i k s a'
	uninstall  = 'g p'
	cleanup    = 'g'
	virustotal = 'a s n'
	update     = 'f g i k s q'
}

$script:ScoopLongParams = @{
	install    = 'global independent no-cache skip arch'
	uninstall  = 'global purge'
	cleanup    = 'global'
	virustotal = 'arch scan no-depends'
	update     = 'force global independent no-cache skip quiet'
}

$script:ScoopParamValues = @{
	install    = @{
		a    = '32bit 64bit'
		arch = '32bit 64bit'
	}
	virustotal = @{
		a    = '32bit 64bit'
		arch = '32bit 64bit'
	}
}

$script:ScoopCommandsWithLongParams = $ScoopLongParams.Keys -join '|'
$script:ScoopCommandsWithShortParams = $ScoopShortParams.Keys -join '|'
$script:ScoopCommandsWithParamValues = $ScoopParamValues.Keys -join '|'

# 6> redirect Write-Host's output, (〒︿〒)
$script:ScoopAliasMap = @{ }
& scoop alias list 6>$null |
Out-String -Stream |
ForEach-Object { if ( $_ -match '^(?<alias>[\w]+)\s+(?<cmd>.*)$' ) {
		$script:ScoopAliasMap[$matches['alias']] = $matches['cmd'].TrimEnd() 
	} 
}
function script:ScoopAlias($filter) {
	@($script:ScoopAliasMap.Keys |
		Where-Object { $_ -like "$filter*" }
	)
}

function script:ScoopExpandCmdParams($commands, $command, $filter) {
	$commands.$command -split ' ' | Where-Object { $_ -like "$filter*" }
}

function script:ScoopExpandCmd($filter, $includeAliases) {
	$cmdList = @()
	$cmdList += $ScoopCommands
	if ($includeAliases) {
		$cmdList += ScoopAlias
	}
	$cmdList -like "$filter*" | Sort-Object
}

function script:ScoopLocalPackages($filter) {
	if ($global:ScoopCompletionUseLocalData) {
		@(& Get-ChildItem -Path $scoopdir\apps -Name -Directory |
			Where-Object { $_ -ne "scoop" } |
			Where-Object { $_ -like "$filter*" }
		)
	}
	else {
		@(& scoop list 6>&1 |
			ForEach-Object { if ( $_ -match '^\s*([\w][\-\.\w]*) $' ) { "$($Matches[1])" } } |
			Where-Object { $_ -like "$filter*" }
		)
	}
}

$script:ScoopRemoteCache = @()
$script:ScoopRemoteCacheNoInit = $true
function script:ScoopRemotePackages($filter) {
	if ($global:ScoopCompletionUseLocalData) {
		# FIXME:remove Recurse
		@(& Get-ChildItem -Path $scoopdir\buckets\ -Name | 
			ForEach-Object { Get-ChildItem -Path $scoopdir\buckets\$_\bucket -Name -Filter *.json } |
			ForEach-Object { if ( $_ -match '^.*?([\w][\-\.\w]*)\.json$' ) { "$($Matches[1])" } } |
			Where-Object { $_ -like "$filter*" }
		)
	}
	else {
		if ($script:ScoopRemoteCacheNoInit) {
			$script:ScoopRemoteCache = @(& scoop search 6>&1 |
				ForEach-Object { if ( $_ -match '^\s*([\w][\-\.\w]*) \(.+\)$' ) { "$($Matches[1])" } } |
				Sort-Object -Unique
			)
			$script:ScoopRemoteCacheNoInit = $false
		}
		@($script:ScoopRemoteCache |
			Where-Object { $_ -like "$filter*" }
		)
	}
}

function script:ScoopLocalCaches($filter) {
	@(& scoop cache show $filter |
		Out-String -Stream |
		ForEach-Object { if ( $_ -match '^\s*[\.1-9]+ [KMGB]+ ([\w][\-\.\w]*) .*$' ) { "$($Matches[1])" } } |
		Sort-Object -Unique |
		Where-Object { $_ -like "$filter*" }
	)
}

function script:ScoopLocalBuckets($filter) {
	@(& scoop bucket list | Where-Object { $_ -like "$filter*" })
}

function script:ScoopRemoteBuckets($filter) {
	@(& scoop bucket known | Where-Object { $_ -like "$filter*" })
}

function script:ScoopExpandLongParams($cmd, $filter) {
	$ScoopLongParams[$cmd] -split ' ' |
	Where-Object { $_ -like "$filter*" } |
	Sort-Object |
	ForEach-Object { -join ("--", $_) }
}

function script:ScoopExpandShortParams($cmd, $filter) {
	$ScoopShortParams[$cmd] -split ' ' |
	Where-Object { $_ -like "$filter*" } |
	Sort-Object |
	ForEach-Object { -join ("-", $_) }
}

function script:ScoopExpandParamValues($cmd, $param, $filter) {
	$ScoopParamValues[$cmd][$param] -split ' ' |
	Where-Object { $_ -like "$filter*" } |
	Sort-Object
}

function script:ScoopTabExpansion($lastBlock) {

	switch -regex ($lastBlock) {
		# Handles Scoop <cmd> --<param> <value>
		"^(?<cmd>$ScoopCommandsWithParamValues).* --(?<param>.+) (?<value>\w*)$" {
			if ($ScoopParamValues[$matches['cmd']][$matches['param']]) {
				return ScoopExpandParamValues $matches['cmd'] $matches['param'] $matches['value']
			}
		}

		# Handles Scoop <cmd> -<shortparam> <value>
		"^(?<cmd>$ScoopCommandsWithParamValues).* -(?<param>.+) (?<value>\w*)$" {
			if ($ScoopParamValues[$matches['cmd']][$matches['param']]) {
				return ScoopExpandParamValues $matches['cmd'] $matches['param'] $matches['value']
			}
		}

		# Handles uninstall package names
		"^(uninstall|cleanup|virustotal|update|prefix|reset|hold|unhold)\s+(?:.+\s+)?(?<package>[\w][\-\.\w]*)?$" {
			return ScoopLocalPackages $matches['package']
		}

		# Handles install package names
		"^(install|info|home|depends)\s+(?:.+\s+)?(?<package>[\w][\-\.\w]*)?$" {
			return ScoopRemotePackages $matches['package']
		}

		# Handles cache (rm/show) cache names
		"^cache (rm|show)\s+(?:.+\s+)?(?<cache>[\w][\-\.\w]*)?$" {
			return ScoopLocalCaches $matches['cache']
		}

		# Handles bucket rm bucket names
		"^bucket rm\s+(?:.+\s+)?(?<bucket>[\w][\-\.\w]*)?$" {
			return ScoopLocalBuckets $matches['bucket']
		}

		# Handles bucket add bucket names
		"^bucket add\s+(?:.+\s+)?(?<bucket>[\w][\-\.\w]*)?$" {
			return ScoopRemoteBuckets $matches['bucket']
		}

		# Handles alias rm alias names
		"^alias rm\s+(?:.+\s+)?(?<alias>[\w][\-\.\w]*)?$" {
			return ScoopAlias $matches['alias']
		}

		# Handles Scoop help <cmd>
		"^help (?<cmd>\S*)$" {
			return ScoopExpandCmd $matches['cmd'] $false
		}

		# Handles Scoop <cmd> <subcmd>
		"^(?<cmd>$($ScoopSubcommands.Keys -join '|'))\s+(?<op>\S*)$" {
			return ScoopExpandCmdParams $ScoopSubcommands $matches['cmd'] $matches['op']
		}

		# Handles Scoop <cmd>
		"^(?<cmd>\S*)$" {
			return ScoopExpandCmd $matches['cmd'] $true
		}

		# Handles Scoop <cmd> --<param>
		"^(?<cmd>$ScoopCommandsWithLongParams).* --(?<param>\S*)$" {
			return ScoopExpandLongParams $matches['cmd'] $matches['param']
		}

		# Handles Scoop <cmd> -<shortparam>
		"^(?<cmd>$ScoopCommandsWithShortParams).* -(?<shortparam>\S*)$" {
			return ScoopExpandShortParams $matches['cmd'] $matches['shortparam']
		}
	}
}

function script:Get-AliasPattern($exe) {
	$aliases = @($exe, "$exe\.ps1", "$exe\.cmd") + @(Get-Alias | Where-Object { $_.Definition -eq $exe } | Select-Object -Exp Name)
	"($($aliases -join '|'))"
}

if (Test-Path Function:\TabExpansion) {
	Rename-Item Function:\TabExpansion TabExpansionBackup_Scoop
}

$script:ScoopIsAlias = $false
function script:ScoopAliasReplace([String]$cli) {
	foreach ($k in $script:ScoopAliasMap.Keys) {
		if ($cli -match "^$k\s+.*$") {
			$script:ScoopIsAlias = $true
			$cli = [regex]::Replace($cli, "^$k\b", $script:ScoopAliasMap[$k])
		}
	}
	return $cli
}

function TabExpansion($line, $lastWord) {
	$lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()

	switch -regex ($lastBlock) {
		# Execute Scoop tab completion for all Scoop-related commands
		"^$(Get-AliasPattern scoop)\s+(?<rest>.*)$" {
			$rest = $matches['rest']
			$script:ScoopIsAlias = $false
			if ($rest -match '^\S+\s+.*$') {
				$rest = ScoopAliasReplace $rest
			}
			if ($script:ScoopIsAlias) {
				TabExpansion $rest $lastWord
			}
			else {
				ScoopTabExpansion $rest
			}
		}

		# Fall back on existing tab expansion
		default {
			if (Test-Path Function:\TabExpansionBackup_Scoop) {
				TabExpansionBackup_Scoop $line $lastWord
			}
		}
	}
}

$exportModuleMemberParams = @{
	Function = @(
		'TabExpansion'
	)
}

Export-ModuleMember @exportModuleMemberParams
