@{
    RootModule           = 'SimpleDockerApps'
    ModuleVersion        = '0.2.0'
    GUID                 = 'db48be46-5aeb-4042-9a74-1c8d9af06e05'
    Author               = 'Stefan Jarina'
    CompanyName          = 'jarina.io'
    Copyright            = '(c) Stefan Jarina. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'A PowerShell module for simplified creation of various servers or apps in a docker container'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Compatible Powershell Editions (Accepted values Desk, Core)
    CompatiblePSEditions = @("Core", "Desk")

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    # FunctionsToExport = "*"
   
    FunctionsToExport    = @(
        "Get-SdaConfigFileLocation",
        "Get-SdaConfigDetails",
        "Remove-SdaImages",
        "New-SdaNetwork",
        "Get-SdaService",
        "Start-SdaService",
        "Stop-SdaService",
        "Remove-SdaService",
        "New-SdaService",
        "Connect-SdaService"
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @()

    # Variables to export from this module
    VariablesToExport    = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @("docker", "SimpleContainers", "containers", "powershell", "core", "Windows", "Linux", "Mac")

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/stefanjarina/SimpleDockerApps/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/stefanjarina/SimpleDockerApps'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
