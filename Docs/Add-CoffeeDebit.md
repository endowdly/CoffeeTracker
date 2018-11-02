---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# Add-CoffeeDebit

## SYNOPSIS
Add debit Data to CoffeeTracker File.

## SYNTAX

```
Add-CoffeeDebit [[-Cups] <Int32>] [[-Date] <DateTime>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds credit Data to CoffeeTracker File by reading the Json data, converting it to a PowerShell object,
changing the data, converting it back to Json data, and resetting the file.

## EXAMPLES

### EXAMPLE 1
```
Add-CoffeeDebit -Cups 2
```

Adds 2 Cups to the Tracker.Debit Data of CoffeeTracker File.

## PARAMETERS

### -Cups
The amount of cups taken.
Default: 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
The Date of the taking: Default: Now

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: [System.DateTime]::Now
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
