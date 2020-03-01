########## PRIVATE FUNCTIONS ##########
#######################################

function ConvertFrom-JsonWithComments {
  <#
  .SYNOPSIS
    Converts a .jsonc string to a JsonObject.
  .DESCRIPTION
    This command converts a Json with Comments string representation to a JsonObject.
  .INPUTS
    System.String
  .OUTPUTS
    System.Object
  #>
  param (
    # Input object of type string which will be converted from JSON
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [AllowEmptyString()]
    [string]$InputObject
  )
  
  if ( $PSVersionTable.PSVersion.Major -gt 5 ) {
    return $Input | ConvertFrom-Json
  }
  else {
    $Input = ($Input -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/')
    return $Input | ConvertFrom-Json
  }
}

function Test-SdaNetworkStatus {
  <#
  .SYNOPSIS
    Checks if requested network already exists
  .DESCRIPTION
    This command wil query information about networks via docker cli and checks if requested network already exists
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    Boolean
  #>
  param (
    # Name of the network
    [string]$Name = (Get-SdaConfig).defaultNetwork,
    # Only return, no output to console
    [switch]$JustConfirm = $false
  )
  $status = docker network ls --filter "name=^$Name$" --format '{{.Name}}'
  if ($null -ne $status) {
    if (-not $JustConfirm) {
      Write-Host "Network '$Name' exists, everything looks alright."
    }
    $true
  }
  else {
    if (-not $JustConfirm) {
      Write-Host "Network '$Name' doesn't exist..."
    }
    $false
  }
}

function Invoke-SolrCoreCreation {
  param (
    $User,
    $Prefix,
    $Name
  )
  ### SOLR specific
  # To use Solr so called 'core' needs to be created
  docker exec -it --user=$User "$Prefix-$Name" bin/solr create_core -c defaultcore
  if ($?) { 
    Write-Output "core created with name 'defaultcore'"
  }
  else {
    Write-Error "Error creating core"
    break
  }
}

function Get-Confirmation {
  <#
  .SYNOPSIS
    Gets confirmation from user with custom message
  .DESCRIPTION
    This command will get confirmation from user with custom message and returns true or false
  .EXAMPLE
    PS C:\> Get-Confirmation -Message "Are you sure?"
      Are you sure? (Y/n)
      True
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    Boolean
  #>
  param (
    # Custom message you want to confirm
    [string]$Message = "Are you sure you want to proceed?"
  )
  $confirmation = Read-Host "$Message (Y/n)"
  switch -Regex ($confirmation) {
    '[Nn]' { $false }
    Default { $true }
  }
}

function New-SdaDockerCommand {
  <#
  .SYNOPSIS
    Constructs docker command string
  .DESCRIPTION
    This command will get confirmation from user with custom message and returns true or false
  .EXAMPLE
    $service.docker | New-SdaDockerCommand -Name mssql -Prefix sda -Network sda -Version latest -Pass Start123++
      docker create --net sda --name sda-mssql --ulimit nofile=262144:262144 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Start123++' -e 'MSSQL_PID=Express' -v sda-mssql-data:/var/opt/mssql -p 1433:1433 mcr.microsoft.com/mssql/server:latest
  .INPUTS
    PSCustomObject
      Docker section from specific service configuration
  .OUTPUTS
    String
  #>
  param (
    # Docker section from specific service configuration
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [PSCustomObject]$DockerConfig,
    # Name of service
    [string]$Name,
    # Prefix from configuration
    [string]$Prefix,
    # Name of network to attach to
    [string]$Network,
    # Version of docker image
    [string]$Version,
    # Password
    [string]$Pass
  )

  # Base command
  $command = "docker create --net $Network --name $Prefix-$Name $($DockerConfig.AdditionalDockerArguments -join " ")"

  # Add Environment Variables (if any)
  if ($DockerConfig.EnvVars.Length -gt 0) {
    $DockerConfig.EnvVars | ForEach-Object {
      $command += " -e ""$(Format-SdaPlaceholder -Name PASSWORD -Source $_ -Value $Pass)"""
    }
  }

  # Add Volumes (if any)
  if ($DockerConfig.Volumes.Length -gt 0) {
    $DockerConfig.Volumes | ForEach-Object {
      $command += " -v $Prefix-$(Format-SdaPlaceholder -Name NAME -Source $_.Source -Value $Name):$($_.Target)"
    }
  }

  # Add Ports (if any)
  if ($DockerConfig.PortMappings.Length -gt 0) {
    $DockerConfig.PortMappings | ForEach-Object {
      $command += " -p $($_.host):$($_.container)"
    }
  }

  # Add Image Info + Custom App Command
  $command += " $($DockerConfig.ImageName):$($Version) $($DockerConfig.CustomAppCommands)"

  # Return command for execution
  $command
}

function Get-SdaConfig {
  <#
  .SYNOPSIS
    Gets configuration object
  .DESCRIPTION
    This command will read the json configuration and converts it to Object
  .OUTPUTS
    PSCustomObject
      Powershell object representation of json configuration
  #>
  if (Test-Path $PSScriptRoot/config.json) {
    Write-Output (Get-Content $PSScriptRoot/config.json -Raw | ConvertFrom-JsonWithComments)
  }
  else {
    Throw "Config file does not exist"
  }
}

function Get-SdaServiceFromConfig {
  <#
  .SYNOPSIS
    Gets service information from configuration object
  .DESCRIPTION
    This command will return a specific service from configuration object
  .OUTPUTS
    PSCustomObject
      Powershell object representation of particular service from configuration
  #>
  param (
    # Configuration object
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [System.Object]$Config,
    # Name of service
    [string]$Name
  )
  return $Config.services | Where-Object { $_.Name -eq "$Name" }
}

function Write-SdaDefaultWarning {
  <#
  .SYNOPSIS
    Writes a custom message to standard output
  .DESCRIPTION
    This command returns a custom message to warn user about important action
  .OUTPUTS
    None. This command does not generate any output.
  #>
  param (
    # Command to run again with
    [string]$Command,
    # Provided value which was used
    [string]$Value,
    # Output name of a service from configuration ($service.OutputName)
    [string]$Name,
    # Action we are doing
    [string]$Action = "Creating",
    # Type of a warning
    [string]$Type = "password"
  )
  Write-Output "$Action '$Name' in Docker container using the default $Type '$Value'"
  Write-Output "For custom $Type run again with: '$Command'"
  if ($Type -eq "password" -and $Action -eq "Creating") {
    Write-Output "Password must be strong, otherwise docker fails to create container"
  }
}

function Format-SdaPlaceholder {
  <#
  .SYNOPSIS
    Replace {PLACEHOLDER} in a string with a value
  .DESCRIPTION
    This command replaces a placeholder in a string with actual value, if no placeholder return original string
  .EXAMPLE
    PS C:\> Format-SdaPlaceholder "Hello {NAME}" -Name NAME -Value "Stefan"
      Hello Stefan
  .EXAMPLE
    PS C:\> "Hello {NAME}, nice to see you" | Format-SdaPlaceholder -Name NAME -Value "Stefan"
      Hello Stefan, nice to see you
  .INPUTS
    String
  .OUTPUTS
    String
  #>
  param(
    # Source string in which replacement will be performed
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [AllowEmptyString()]
    [string]$Source,
    # Name of a placeholder (e.g. NAME for a {NAME} placeholder)
    [string]$Name,
    # Value to replace with
    [string]$Value
  )

  if ($Source -match "\{$Name\}") {
    return $Source -replace "\{$Name\}", "$Value"
  }
  else {
    return $Source
  }
}

function Get-SdaServicesAvailable {
  <#
  .SYNOPSIS
    Lists all available services
  .DESCRIPTION
    Lists all available services that are configured
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    PSCustomObject
  #>
  (Get-SdaConfig).services | ForEach-Object { [PSCustomObject]@{SDA = $_.OutputName ; Name = $_.Name } }
}

function Get-SdaServicesCreated {
  <#
  .SYNOPSIS
    Lists all created services
  .DESCRIPTION
    Lists all created services that are available in docker
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    PSCustomObject
  #>
  $prefix = (Get-SdaConfig).prefix
  $services = docker container ls -a -f "name=$prefix-" --format '{{json .}}' | ConvertFrom-Json
  foreach ($service in $services) {
    $output = [PSCustomObject]@{
      Name          = $service.Names.Substring($prefix.Length + 1)
      ContainerName = $service.Names
      ID            = $service.ID
      Image         = $service.Image
      Networks      = $service.Networks
      Ports         = $service.Ports
      Status        = $service.Status
    }

    Write-Output $output
  }
}

function Get-SdaServicesRunning {
  <#
  .SYNOPSIS
    Lists all running services
  .DESCRIPTION
    Lists all running services that are available in docker
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    PSCustomObject
  #>
  Get-SdaServicesCreated | Where-Object { $_.Status -match "^Up.*" }
}

function Get-SdaServicesStopped {
  <#
  .SYNOPSIS
    Lists all stopped services
  .DESCRIPTION
    Lists all stopped services that are available in docker
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    PSCustomObject
  #>
  Get-SdaServicesCreated | Where-Object { $_.Status -notmatch "^Up.*" }
}

########## PUBLIC FUNCTIONS ###########
#######################################

## INFO cmdlets

function Get-SdaConfigFileLocation {
  <#
  .SYNOPSIS
    Returns a location to a default config file.
  .DESCRIPTION
    Returns a location to default config file that is required for this module to function
  .OUTPUTS
    String
  #>
  Write-Output (Join-Path $PSScriptRoot "config.json")
}

function Get-SdaConfigDetails {
  <#
  .SYNOPSIS
    Returns json representation of a configuration, either general, or of specific service
  .DESCRIPTION
    Returns json representation of a configuration, either general, or of specific service
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    String
  #>
  param (
    # Name of a service
    [string]$Name
  )
  $config = Get-SdaConfig
  if ($Name) {
    $server = $config | Get-SdaServiceFromConfig -Name $Name
    if ($null -ne $server) {
      $server | ConvertTo-Json -Depth 3
    }
    else {
      Write-Error "Specified server '$Name' is not available yet."
    }
  }
  else {
    Write-Output @{
      Prefix          = $config.prefix
      DefaultNetwork  = $config.defaultNetwork
      DefaultPassword = $config.defaultPassword
    } | ConvertTo-Json -Depth 3
  }
}

## IMAGE management
function Remove-SdaImages {
  <#
  .SYNOPSIS
    Removes dangling docker images
  .DESCRIPTION
    Removes all images that are not associated with other resources (so called dangling images)
    Images can be downloaded again in case you remove more than you want.
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    None. This command does not generate any output.
  #>
  param(
    # Specify if remove only dangling
    [switch]$Dangling
  )
  if ($Dangling) {
    if (Get-Confirmation -Message "Are you sure you want to remove all dangling images?") {
      $danglingImages = docker images -f "dangling=true" -q
      if ($null -ne $danglingImages) {
        docker rmi -f $danglingImages
      }
      else {
        Write-Host "No dangling images were found"
      }
      
    }
  }
  else {
    if (Get-Confirmation -Message "Are you sure you want to remove all images?") {
      $dockerImages = docker images --format '{{json .}}' | ConvertFrom-Json
      foreach ($image in $dockerImages) {
        $service = (Get-SdaConfig).services | Where-Object { $_.docker.imageName -eq $image.Repository }
        if ($service.Length -gt 0) {
          docker rmi -f $image.ID | Out-Null
          if ($?) {
            Write-Host "Image '$($image.ID)' was removed"
          }
        }
      }
    }
  }
  
}

## NETWORK management

function New-SdaNetwork {
  <#
  .SYNOPSIS
    Creates new docker network
  .DESCRIPTION
    Creates new docker network
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    None. This command does not generate any output.
  #>
  param (
    # Name of a network to create (Defaults to network specified in config)
    $Name = (Get-SdaConfig).DefaultNetwork
  )
  if (-not (Test-SdaNetworkStatus -Name $Name -JustConfirm)) {
    if (Get-Confirmation -Message "Are you sure you want to create network '$Name'?") {
      docker network create $Name
      if ($?) {
        Write-Host "Network successfuly created."
      }
    }
    else {
      Write-Host "Skipping network creation..."
    }
  }
}

## SERVICE management

function Get-SdaService {
  <#
  .SYNOPSIS
    Get information about specific service, or list of running, available, stopped and created services
  .DESCRIPTION
    Get information about specific service, or list of running, available, stopped and created services
    Defaults to list running services if no Name, or one of [Available, Running, Stopped, Created] is given
  .EXAMPLE
    PS C:\> Get-SdaService -Name mssql
      Name                           Value
      ----                           -----
      Status                         running
      Container                      sda-mssql
      Name                           mssql
  .EXAMPLE
    PS C:\> Get-SdaService     # Defaults to list running services
      Name                           Value
      ----                           -----
      Ports                          0.0.0.0:1433->1433/tcp
      Image                          mcr.microsoft.com/mssql/server:latest
      ID                             243a8ebb4118
      Status                         Up 51 minutes
      Name                           sda-mssql
      Networks                       simple-docker-apps
  .EXAMPLE
    PS C:\> Get-SdaService -Running

    Lists running SDA services

    Name                           Value
    ----                           -----
    Ports                          0.0.0.0:1433->1433/tcp
    Image                          mcr.microsoft.com/mssql/server:latest
    ID                             243a8ebb4118
    Status                         Up 51 minutes
    Name                           sda-mssql
    Networks                       simple-docker-apps
  .EXAMPLE
    PS C:\> Get-SdaService -Available
    Name                           Value
    ----                           -----
    MS SQL                         mssql
    PostgreSQL                     postgres
  .EXAMPLE
    PS C:\> Get-SdaService -Created
    Name                           Value
    ----                           -----
    Ports                          0.0.0.0:1433->1433/tcp
    Image                          mcr.microsoft.com/mssql/server:latest
    ID                             243a8ebb4118
    Status                         Up 54 minutes
    Name                           sda-mssql
    Networks                       simple-docker-apps

    Ports                          0.0.0.0:5432->5432/tcp
    Image                          postgres:11
    ID                             75eb3b089d5b
    Status                         Exited (255) 2 hours ago
    Name                           sda-postgres
    Networks                       simple-docker-apps
  .EXAMPLE
    PS C:\> Get-SdaService -Stopped
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    PSCustomObject
      For no arguments, or -Name, -Running, -Stopped, -Created
    object[]
      For -Available
  #>
  param (
    # Name of service, when specified, other switches are ignored
    [string]$Name,
    # Switch to list all available services
    [switch]$Available,
    # Switch to list all running services
    [switch]$Running,
    # Switch to list all stopped services
    [switch]$Stopped,
    # Switch to list all created services
    [switch]$Created,
    # Switch to suppress Write-Error and return only $null. Usefull in scripting
    [switch]$SupressOutHost
  )
  $config = Get-SdaConfig
  if ($Name.Length -gt 0) {
    $service = $config | Get-SdaServiceFromConfig -Name $Name
    if ($null -eq $service) {
      Write-Output "The SDA service '$Name' does not exist, here is a list of all available services:"
      Get-SdaServicesAvailable
      break;
    }
    else {
      $containerName = "$($config.prefix)-$($service.Name)"
      #$containerName = "$($service.Name)"
      $info = docker container inspect $containerName --format '{{json .State}}' 2>$null | ConvertFrom-Json
      if ($null -ne $info) {
        [PSCustomObject]@{
          Name      = $service.Name
          Container = $containerName
          Status    = $info.Status
        }
      }
      else {
        if (-not ($SupressOutHost)) {
          Write-Host "ERROR: Container '$containerName' doesn't exist"
        }
        $null
      }
    }
  }
  elseif ($Available) {
    Get-SdaServicesAvailable
  }
  elseif ($Running) {
    Get-SdaServicesRunning
  }
  elseif ($Created) {
    Get-SdaServicesCreated
  }
  elseif ($Stopped) {
    Get-SdaServicesStopped
  }
  else {
    Get-SdaServicesRunning
  }
}

function Start-SdaService {
  <#
  .SYNOPSIS
    Creates new docker network
  .DESCRIPTION
    Creates new docker network
  .INPUTS
    PSCustomObject
      Object returned from Get-Services
  .OUTPUTS
    PSCustomObject
      Object with new status of a service
  #>
  param (
    # Service name
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, Mandatory = $true)]
    [string]$Name
  )
  process {
    $info = Get-SdaService -Name $Name
    if ($null -ne $info) {
      if ($info.Status -ne "running") {
        docker start $info.Container | Out-Null
        Get-SdaService -Name $Name
      }
      else {
        $info
      }
    }
  }
}

function Stop-SdaService {
  <#
  .SYNOPSIS
    Creates new docker network
  .DESCRIPTION
    Creates new docker network
  .INPUTS
    PSCustomObject
      Object returned from Get-Services
  .OUTPUTS
    PSCustomObject
      Object with new status of a service
  #>
  param (
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, Mandatory = $true)]
    [string]$Name,
    [switch]$Kill
  )
  process {
    $info = Get-SdaService -Name $Name
    if ($null -ne $info) {
      if ($info.Status -eq "running") {
        if ($Kill) {
          docker kill $info.Container | Out-Null
          Get-SdaService -Name $Name
        }
        else {
          docker stop $info.Container -t 10 | Out-Null
          Get-SdaService -Name $Name
        }
      }
      else {
        $info
      }
    }
  }
}

function Remove-SdaService {
  <#
  .SYNOPSIS
    Creates new docker network
  .DESCRIPTION
    Creates new docker network
  .INPUTS
    PSCustomObject
      Object returned from Get-Services
  .OUTPUTS
    PSCustomObject
      Object with new status of a service
  #>
  param(
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, Mandatory = $true)]
    [string]$Name,
    [switch]$Volumes
  )
  process {
    $info = Get-SdaService -Name $Name
    if ($Volumes) {
      $msg = "Are you sure you want to remove '$Name' and all associated volumes?"
    }
    else {
      $msg = "Are you sure you want to remove '$Name'?"
    }
    if (-not (Get-Confirmation -Message $msg)) {
      break
    }
    if ($null -ne $info) {
      if ($info.Status -eq "running") {
        if ((Stop-SdaService $Name -Kill).Status -eq "exited") {
          docker container rm $info.Container
        }
      }
      else {
        docker container rm $info.Container
      }
    }
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      $config = Get-SdaConfig
      Write-Host "-Volume flag detected, searching for dangling volumes..."
      $serviceVolumes = docker volume ls -f "dangling=true" -f "name=$($config.prefix)-$Name-" --format '{{json .Name}}' | ConvertFrom-Json

      # fix the type
      if ($serviceVolumes.GetType().Name -eq "String") {
        $serviceVolumes = @($serviceVolumes)
      }

      if ($serviceVolumes.Length -gt 0) {
        Write-Host "Found $($serviceVolumes.Length) volumes, attempting to remove..."
        foreach ($volume in $serviceVolumes) {
          if (-not (Get-Confirmation -Message "Are you sure you want to remove '$volume'")) {
            continue
          }
          docker volume rm $volume | Out-Null
          if ($?) {  
            Write-Output "'$volume' successfuly removed."
          }
          else {
            Write-Output "ERROR: Problem removing '$volume', manual action might be needed"
          }
        }
      }
      else {
        Write-Host "No volumes found"
      }
    }
  }
}

function New-SdaService {
  <#
  .SYNOPSIS
    Creates new service
  .DESCRIPTION
    Creates new SDA service.
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    Output (if any)
  #>
  param (
    # Service name
    [Parameter(Mandatory)]
    [string]$Name,
    # Password, will be used instead of default from config
    [string]$Pass = "",
    # Network name, will be used instead of default from config
    [string]$Network,
    # Version, will be used instead of default from config
    [string]$Version
  )
  # Get necessary configuration
  $config = Get-SdaConfig
  $service = Get-SdaServiceFromConfig -Config $config -Name $Name

  # Check if service really exists
  if ($null -eq $service) {
    Write-Output "The SDA service '$Name' does not exist, here is a list of all available services:"
    Get-SdaServicesAvailable
    break;
  }
  
  # Check if really use default password
  if ($Pass -eq "" -and $service.HasPassword) {
    Write-SdaDefaultWarning -Command "New-SdaService -Name $Name -Pass <SA_PASSWORD>" -Value $config.DefaultPassword -Name $service.outputName
    if (-not (Get-Confirmation)) { break }
  }

  # Check if requested service is already running
  $info = Get-SdaService -Name $Name -SupressOutHost
  if ($null -ne $info) {
    if (Get-Confirmation -Message "Container already exists. Do you want me to destroy it?") {
      if ((Stop-SdaService -Name $Name -Kill).Status -eq "exited") { Remove-SdaService -Name $Name }
    }
    else {
      break
    }
  }

  # Check if Network exists
  if ($Network -eq "") {
    $Network = $config.DefaultNetwork
  }
  if (-not (Test-SdaNetworkStatus -Name $Network -JustConfirm)) {
    New-SdaNetwork -Name $Network
  }

  $params = @{
    Name         = $Name
    Version      = if ($Version) { "$Version" } else { "$($service.DefaultVersion)" }
    Pass         = if ($Pass -ne "") { "$Pass" } else { "$($config.DefaultPassword)" }
    Network      = $Network
    Prefix       = $config.prefix
    DockerConfig = $service.docker
  }

  Invoke-Expression (New-SdaDockerCommand @params)
  if ($?) { 
    Write-Output "Container created"
  }
  else {
    Write-Error "Error creating container. Exiting..."
    break
  }
  $info = Start-SdaService -Name $Name
  if ($info.Status -eq "running") { 
    Write-Output "Container started"
  }
  else {
    Write-Error "Error starting container"
    break
  }

  ## SOLR specific TODO: find better place for this
  if ($Name -eq "solr") {
    Invoke-SolrCoreCreation -Name "solr" -Prefix $config.Prefix -User "solr"
  }
}

function Connect-SdaService {
  <#
  .SYNOPSIS
    Connects to a service inside the docker container
  .DESCRIPTION
    Connects to a service inside running container. It leverages the 'docker exec -it' command.
  .INPUTS
    None. You cannot pipe objects to this command
  .OUTPUTS
    None. This command does not generate any output
  #>
  param (
    # Service name
    [Parameter(Mandatory)]
    [string]$Name,
    # Password, will be used instead of default from config
    [string]$Pass = "",
    # Specify if open web browser instead
    [switch]$Web
  )

  # Get configuration
  $config = Get-SdaConfig
  $service = Get-SdaServiceFromConfig -Config $config -Name $Name

  # Check if service really exists
  if ($null -eq $service) {
    Write-Output "The SDA service '$Name' does not exist, here is a list of all available services:"
    Get-SdaServicesAvailable
    break;
  }

  # Check if we can connect to service via cli
  if (-not ($service.HasCliConnect)) {
    Write-Error "The SDA service '$Name' does not support CLI connection"
    break
  }

  # Check if service has url specified in config if -Web passed
  if ($Web -and (-not $service.HasWebConnect)) {
    Write-Error "The SDA service '$Name' does not support web dashboard"
    break
  }

  # Check if service is running
  $info = Get-SdaService -Name $Name
  if ($null -eq $info) {
    Write-Error "The SDA service '$Name' is not running, Please start service first with 'Start-SdaService -Name $Name'"
    break
  }

  if ($Web) {
    $url = $service.WebConnectUrl
    Write-Output "Connecting to $($service.OutputName) web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste address in manually"
    if (-not (Get-Confirmation)) {
      break
    }

    if ($IsLinux) {
      xdg-open $url
      break
    }
    elseif ($IsMacOS) {
      open $url
      break
    }
    else {
      Start-Process $url
      break
    }
  }

  if ($Pass -eq "" -and $service.HasPassword) {
    $Pass = $config.DefaultPassword
    Write-SdaDefaultWarning -Command "Connect-SdaService $Name -Pass <SA_PASSWORD>'" -Action "Connecting to" -Type "password" -Name $service.OutputName -Value $Pass
    
    if (-not (Get-Confirmation)) {
      break
    }
  }
  $cliCommand = Format-SdaPlaceholder -Name PASSWORD -Value $Pass -Source "$($service.CliConnectCommand)"
  docker exec -it "$($config.prefix)-$Name" sh -c "$cliCommand"
}
