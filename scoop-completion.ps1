# Thanks to Posh-Git - https://github.com/dahlbyk/posh-git

$script:ScoopCommands = @('alias', 'bucket', 'cache', 'checkup', 'cleanup', 'config', 'create', 'depends', 'export', 'help', 'home',
	'info', 'install', 'list', 'prefix', 'reset', 'search', 'status', 'uninstall', 'update', 'virustotal', 'which')

$script:ScoopSubcommands = @{
	alias  = 'add list rm'
	bucket = 'add list known rm'
	cache  = 'rm show'
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

# 6> redirect Write-Host output, a hack
function script:ScoopAlias($fliter) {
	@(& scoop alias list 6>$null |
			Out-String -Stream |
			Where-Object { $_ -match '^([\w]+)\s+.*$'} |
			ForEach-Object { $_ -replace '^([\w]+)\s+.*$', '$1' } |
			Where-Object { $_ -like "$filter*" }
	)
}

function script:ScoopAliasCommand($alias) {
	@(& scoop alias list 6>$null |
			Out-String -Stream |
			Where-Object { $_ -match "^$alias\s+.*$" } |
			ForEach-Object { $_ -replace "^$alias\s+(.*)$", '$1' }
	)
}

function script:ScoopExpandAlias($cmd, $others) {
	$alias = ScoopAliasCommand $cmd
	if ($alias) {
		return "scoop $alias$others"
	}
	else {
		return "scoop $cmd$others"
	}
}

function script:ScoopExpandCmdParams($commands, $command, $filter) {
	$commands.$command -split ' ' | Where-Object { $_ -like "$filter*" }
}

function script:ScoopExpandCmd($filter, $includeAliases) {
	$cmdList = @()
	$cmdList += $ScoopCommands -like "$filter*"
	if ($includeAliases) {
		$cmdList += ScoopAlias
	}
	$cmdList | Sort-Object
}

function script:ScoopLocalPackages($filter) {
	@(& scoop list 6>&1 |
			Where-Object { $_ -match '^\s*([\w][\-\.\w]*) $' } |
			ForEach-Object { $_ -replace '^\s*([\w][\-\.\w]*) $', '$1' } |
			Where-Object { $_ -like "$filter*" }
	)
}

$script:ScoopRemoteCache = @()
function script:ScoopRemotePackages($filter) {
	if ($script:ScoopRemoteCache.Count -eq 0) {
		$script:ScoopRemoteCache = @(& scoop search 6>&1 |
				Where-Object { $_ -match '^\s*([\w][\-\.\w]*) \(.+\)$' } |
				ForEach-Object { $_ -replace '^\s*([\w][\-\.\w]*) \(.+\)$', '$1' } |
				Sort-Object -Unique
		)
	}
	@($script:ScoopRemoteCache |
			Where-Object { $_ -like "$filter*" }
	)
}

function script:ScoopLocalCaches($filter) {
	@(& scoop cache show $filter |
			Out-String -Stream |
			Where-Object { $_ -match '^\s*[\.1-9]+ [KMGB]+ ([\w][\-\.\w]*) .*$' } |
			ForEach-Object { $_ -replace '^\s*[\.1-9]+ [KMGB]+ ([\w][\-\.\w]*) .*$', '$1' } |
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

function ScoopTabExpansion($lastBlock) {
	if ($lastBlock -match "^$(Get-AliasPattern scoop) (?<cmd>\S+)(?<others> .*)$") {
		$lastBlock = $(ScoopExpandAlias $matches['cmd'] $matches['others'])
	}

	switch -regex ($lastBlock -replace "^$(Get-AliasPattern scoop) ", "") {
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
		"^(uninstall|cleanup|virustotal|update|prefix|reset)\s+([\-\w][\-\.\w]*\s+)*(?<package>[\w][\-\.\w]*)?$" {
			ScoopLocalPackages $matches['package']
		}

		# Handles install package names
		"^(install|info|home|depends)\s+([\-\w][\-\.\w]*\s+)*(?<package>[\w][\-\.\w]*)?$" {
			ScoopRemotePackages $matches['package']
		}

		# Handles cache (rm/show) cache names
		"^cache (rm|show)\s+([\-\w][\-\.\w]*\s+)*(?<cache>[\w][\-\.\w]*)?$" {
			ScoopLocalCaches $matches['cache']
		}

		# Handles bucket rm bucket names
		"^bucket rm\s+([\-\w][\-\.\w]*\s+)*(?<bucket>[\w][\-\.\w]*)?$" {
			ScoopLocalBuckets $matches['bucket']
		}

		# Handles bucket add bucket names
		"^bucket add\s+([\-\w][\-\.\w]*\s+)*(?<bucket>[\w][\-\.\w]*)?$" {
			ScoopRemoteBuckets $matches['bucket']
		}

		# Handles bucket rm bucket names
		"^alias rm\s+([\-\w][\-\.\w]*\s+)*(?<alias>[\w][\-\.\w]*)?$" {
			ScoopAlias $matches['alias']
		}

		#Handles Scoop help <cmd>
		"^help (?<cmd>\S*)$" {
			ScoopExpandCmd $matches['cmd'] $false
		}

		# Handles Scoop <cmd> <subcmd>
		"^(?<cmd>$($ScoopSubcommands.Keys -join '|'))\s+(?<op>\S*)$" {
			ScoopExpandCmdParams $ScoopSubcommands $matches['cmd'] $matches['op']
		}

		# Handles Scoop <cmd>
		"^(?<cmd>\S*)$" {
			ScoopExpandCmd $matches['cmd'] $true
		}

		# Handles Scoop <cmd> --<param>
		"^(?<cmd>$ScoopCommandsWithLongParams).* --(?<param>\S*)$" {
			ScoopExpandLongParams $matches['cmd'] $matches['param']
		}


		# Handles Scoop <cmd> -<shortparam>
		"^(?<cmd>$ScoopCommandsWithShortParams).* -(?<shortparam>\S*)$" {
			ScoopExpandShortParams $matches['cmd'] $matches['shortparam']
		}
	}
}

function Get-AliasPattern($exe) {
	$aliases = @($exe) + @(Get-Alias | Where-Object { $_.Definition -eq $exe } | Select-Object -Exp Name)
	"($($aliases -join '|'))"
}

if (Test-Path Function:\TabExpansion) {
	Rename-Item Function:\TabExpansion TabExpansionBackup
}

function TabExpansion($line, $lastWord) {
	$lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()

	switch -regex ($lastBlock) {
		# Execute Scoop tab completion for all Scoop-related commands
		"^$(Get-AliasPattern scoop) (.*)" {
			ScoopTabExpansion $lastBlock
		}

		# Fall back on existing tab expansion
		default {
			if (Test-Path Function:\TabExpansionBackup) {
				TabExpansionBackup $line $lastWord
			}
		}
	}
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
