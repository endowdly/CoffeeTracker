---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# Read-CoffeeBalance

## SYNOPSIS
Read the Coffee Balance from the Tracker File.

## SYNTAX

```
Read-CoffeeBalance [-Pretty] [<CommonParameters>]
```

## DESCRIPTION
Read the Coffee Balance from the Tracker File.

## EXAMPLES

### EXAMPLE 1
```
Read-CoffeeBalance
```

Return the balance as an integer of cups.

### EXAMPLE 2
```
Read-CoffeeBalance -Pretty
```

Return the balance as an integer of cups _beautifully_ (for the console).

## PARAMETERS

### -Pretty
Output 'Beautifully'.
Capture this output with the Information Stream (PowerShell 5+)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ConsoleOutput

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
