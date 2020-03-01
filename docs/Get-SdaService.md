---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Get-SdaService

## SYNOPSIS
Get information about specific service, or list of running, available, stopped and created services

## SYNTAX

```
Get-SdaService [[-Name] <String>] [-Available] [-Running] [-Stopped] [-Created] [-SupressOutHost]
```

## DESCRIPTION
Get information about specific service, or list of running, available, stopped and created services
Defaults to list running services if no Name, or one of \[Available, Running, Stopped, Created\] is given

## EXAMPLES

### EXAMPLE 1
```
Get-SdaService -Name mssql
Name                           Value
----                           -----
Status                         running
Container                      sda-mssql
Name                           mssql
```

### EXAMPLE 2
```
Get-SdaService     # Defaults to list running services
Name                           Value
----                           -----
Ports                          0.0.0.0:1433->1433/tcp
Image                          mcr.microsoft.com/mssql/server:latest
ID                             243a8ebb4118
Status                         Up 51 minutes
Name                           sda-mssql
Networks                       simple-docker-apps
```

### EXAMPLE 3
```
Get-SdaService -Running
Name                           Value
----                           -----
Ports                          0.0.0.0:1433->1433/tcp
Image                          mcr.microsoft.com/mssql/server:latest
ID                             243a8ebb4118
Status                         Up 51 minutes
Name                           sda-mssql
Networks                       simple-docker-apps
```

### EXAMPLE 4
```
Get-SdaService -Available
Name                           Value
----                           -----
MS SQL                         mssql
PostgreSQL                     postgres
```

### EXAMPLE 5
```
Get-SdaService -Created
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
```

### EXAMPLE 6
```
Get-SdaService -Stopped
Name                           Value
----                           -----
Ports                          0.0.0.0:5432->5432/tcp
Image                          postgres:11
ID                             75eb3b089d5b
Status                         Exited (255) 2 hours ago
Name                           sda-postgres
Networks                       simple-docker-apps
```

## PARAMETERS

### -Available
Switch to list all available services

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Created
Switch to list all created services

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of service, when specified, other switches are ignored

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Running
Switch to list all running services

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stopped
Switch to list all stopped services

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SupressOutHost
Switch to suppress Write-Error and return only $null.
Usefull in scripting

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. You cannot pipe objects to this command
## OUTPUTS

### PSCustomObject
###   For no arguments, or -Name, -Running, -Stopped, -Created
### object[]
###   For -Available
## NOTES

## RELATED LINKS
