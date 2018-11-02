---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# Add-CoffeeCredit

## SYNOPSIS
Adds credit Data to CoffeeTracker File.

## SYNTAX

```
Add-CoffeeCredit [-Amount] <Double> [-Unit] <UnitCost> [[-Date] <DateTime>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Adds credit Data to CoffeeTracker File by reading the Json data, converting it to a PowerShell object,
changing the data, converting it back to Json data, and resetting the file.

## EXAMPLES

### EXAMPLE 1
```
Add-CoffeeCredit -Amount 25 -Unit Cent
```

Adds 25 Cents to the Tracker.Credit Data of CoffeeTracker File.

## PARAMETERS

### -Amount
The Amount added to the Pot.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unit
The Unit of the Amount.
Can be Dollar or Cent.

```yaml
Type: UnitCost
Parameter Sets: (All)
Aliases:
Accepted values: Cent, Dollar

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
The Date of the Credit.
Default: Now

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
