---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Remove-SdaService

## SYNOPSIS
Removes SDA service

## SYNTAX

```
Remove-SdaService [-Name] <String> [-Volumes] [<CommonParameters>]
```

## DESCRIPTION
Removes SDA service

Can also remove dangling volumes, which is destructive action and will remove all your data without possibility to recover.

## EXAMPLES

### EXAMPLE 1
```
Remove-SdaService mssql
```

Removes service 'mssql'

### EXAMPLE 2
```
Remove-SdaService mssql -Volumes
```

Removes service 'mssql' including all related volumes

### EXAMPLE 3
```
Get-SdaService -Stopped | Remove-SdaService
```

Removes all stopped SDA services

## PARAMETERS

### -Name
Service name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Volumes
Switch to remove also related volumes (THIS IS DESTRUCTIVE ACTION)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PSCustomObject
###   Object returned from Get-Service
## OUTPUTS

### PSCustomObject
###   Object with new status of a service
## NOTES

## RELATED LINKS
