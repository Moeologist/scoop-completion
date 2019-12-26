@{
Author = 'ala'
Description = 'A Scoop tab completion module for PowerShell.'

# Script module or binary module file associated with this manifest.
RootModule = 'scoop-completion.psm1'

# Version number of this module.
ModuleVersion = '0.2.2'

# ID used to uniquely identify this module
GUID = 'e79be23b-d149-46c8-85a3-620f2669d2e1'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

FunctionsToExport = @('TabExpansion')
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess.
# This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData =
@{
    PSData =
    @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('scoop', 'tab', 'completion')

		LicenseUri = 'https://opensource.org/licenses/MIT'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/Moeologist/scoop-completion'
    }
}

}
