---
external help file: SimpleDockerApps-help.xml
Module Name: SimpleDockerApps
online version:
schema: 2.0.0
---

# Remove-SdaImages

## SYNOPSIS
Removes dangling docker images

## SYNTAX

```
Remove-SdaImages [-Dangling]
```

## DESCRIPTION
Removes all images that are not associated with other resources (so called dangling images)
Images can be downloaded again in case you remove more than you want.

## EXAMPLES

### EXAMPLE 1
```
Get-SdaImages
```

Query existing docker images, compare them with config and removes only those that match

### EXAMPLE 2
```
Get-SdaImages -Dangling
```

Removes all dangling images

## PARAMETERS

### -Dangling
Specify if remove only dangling

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

### None. This command does not generate any output.
## NOTES

## RELATED LINKS
