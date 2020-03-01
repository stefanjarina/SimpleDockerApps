---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# New-SdaNetwork

## SYNOPSIS
Creates new docker network

## SYNTAX

```
New-SdaNetwork [[-Name] <Object>]
```

## DESCRIPTION
Creates new docker network of driver type 'bridge'

## EXAMPLES

### EXAMPLE 1
```
Get-SdaNetwork my-network
```

Creates my-network of driver type 'bridge'

## PARAMETERS

### -Name
Name of a network to create (Defaults to network specified in config)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-SdaConfig).DefaultNetwork
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. You cannot pipe objects to this command
## OUTPUTS

### None. This command does not generate any output.
## NOTES

## RELATED LINKS
