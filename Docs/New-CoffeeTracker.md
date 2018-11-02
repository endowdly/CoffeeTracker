---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# New-CoffeeTracker

## SYNOPSIS
Initializes a new CoffeeTrackerFile

## SYNTAX

### PathSet (Default)
```
New-CoffeeTracker [[-Path] <String[]>] [-Cost <Double>] [-Unit <UnitCost>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NameSet
```
New-CoffeeTracker [[-Path] <String[]>] [[-Name] <String>] [-Cost <Double>] [-Unit <UnitCost>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This is really a fancy wrapper for the New-Item Cmdlet.

## EXAMPLES

### EXAMPLE 1
```
New-CoffeeTracker -Cost 25 -Unit Cent
```

Creates a new file at the "~/CoffeeTracker.json" with a blank tracker and the coffee information as initialized.

## PARAMETERS

### -Path
The path of the file or the its intended directory.
Default: USERPROFILE.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $PWD
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the file.
Default: "CoffeeTracker.json"

```yaml
Type: String
Parameter Sets: NameSet
Aliases:

Required: False
Position: 2
Default value: CoffeeTracker.json
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Cost
The unit cost of the coffee.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Unit
The unit of the coffee.
Can be dollar or cent.

```yaml
Type: UnitCost
Parameter Sets: (All)
Aliases:
Accepted values: Cent, Dollar

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Force an existing file to be overwritten.

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

### System.IO.FileInfo
## NOTES

## RELATED LINKS
