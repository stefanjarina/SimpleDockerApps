---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# New-SdaService

## SYNOPSIS
Creates new service

## SYNTAX

```
New-SdaService [-Name] <String> [[-Pass] <String>] [[-Network] <String>] [[-Version] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates new SDA service.
If volumes already exists it will reuse them.

## EXAMPLES

### EXAMPLE 1
```
New-SdaService mssql
```

Creates new service 'mssql' with default settings

### EXAMPLE 2
```
New-SdaService mongodb -Network custom-network -Version 3 -Pass "Start123"
```

Creates new service 'mongodb' with custom network name, versiona and password

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Network name, will be used instead of default from config

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pass
Password, will be used instead of default from config

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Version, will be used instead of default from config

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command
## OUTPUTS

### Output (if any)
## NOTES

## RELATED LINKS
