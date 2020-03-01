---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Connect-SdaService

## SYNOPSIS

Connects to a service inside the docker container

## SYNTAX

```powershell
Connect-SdaService [-Name] <String> [[-Pass] <String>] [-Web] [<CommonParameters>]
```

## DESCRIPTION

Connects to a service inside running container.
It leverages the 'docker exec -it' command.

Also supports opening web dashboard if url is present in config.
It will be opened in default web browser, this functionality is cross-platform

## EXAMPLES

### EXAMPLE 1

```powershell
Connect-SdaService mssql
```

Connects to service 'mssql' with default settings

### EXAMPLE 2

```powershell
Connect-SdaService ravendb -Web
```

Opens configured dashboard url in default browser.

### EXAMPLE 3

```powershell
Connect-SdaService mongodb -Pass "Start123"
```

Connects to service 'mongodb' with custom password

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

### -Web

Specify if open web browser instead

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

### None. You cannot pipe objects to this command

## OUTPUTS

### None. This command does not generate any output

## NOTES

## RELATED LINKS
