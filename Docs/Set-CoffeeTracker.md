---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# Set-CoffeeTracker

## SYNOPSIS
Sets the path of the CoffeeTracker file.

## SYNTAX

```
Set-CoffeeTracker [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the path of the CoffeeTracker file.
Accepts wildcard input.
Does not support literal paths.
Does not support multiple paths.

## EXAMPLES

### EXAMPLE 1
```
Pending
```

## PARAMETERS

### -Path
Specifies a path to one locations.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
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

### System.Object
### Can be a System.String descibing a path or a System.IO.FileInfo object.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
