---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Stop-SdaService

## SYNOPSIS
Stops SDA service

## SYNTAX

```
Stop-SdaService [-Name] <String> [-Kill] [<CommonParameters>]
```

## DESCRIPTION
Stops SDA service

## EXAMPLES

### EXAMPLE 1
```
Stop-SdaService mssql
```

Stops service 'mssql'

### EXAMPLE 2
```
Get-SdaService -Running | Stop-SdaService
```

Stops all running SDA services

## PARAMETERS

### -Kill
Switch to kill instead of graceful shutdown

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
