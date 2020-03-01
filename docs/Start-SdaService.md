---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Start-SdaService

## SYNOPSIS
Starts SDA service

## SYNTAX

```
Start-SdaService [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Starts SDA service

## EXAMPLES

### EXAMPLE 1
```
Start-SdaService mssql
```

Starts service 'mssql'

### EXAMPLE 2
```
Get-SdaService -Stopped | Start-SdaService
```

Starts all stopped SDA services

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
