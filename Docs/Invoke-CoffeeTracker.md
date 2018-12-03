---
external help file: CoffeeTracker-help.xml
Module Name: CoffeeTracker
online version:
schema: 2.0.0
---

# Invoke-CoffeeTracker

## SYNOPSIS
The main function to change your CoffeeTracker File!

## SYNTAX

### Add (Default)
```
Invoke-CoffeeTracker [[-Amount] <Double>] [[-Unit] <UnitCost>] [-Date <DateTime>] [-Add] [-Silent]
 [<CommonParameters>]
```

### Take
```
Invoke-CoffeeTracker [[-Cups] <Int32>] [-Date <DateTime>] [-Take] [-Silent] [<CommonParameters>]
```

## DESCRIPTION
The **Invoke-CoffeeTracker** cmdlet is a wrapper to functions that manipulate the credit and debit data stored
in your CofeeTracker File.
You can \`-Add\` or \`-Take\` Coffee from the pot.
When you _take_, you denote the action
in cups of cofee.
When you _add_, you denote the action in amount of money added to the pot.
If you explicitly
use the \`-Amount\` and \`-Unit\` parameters, \`-Add\` is unnecessary.
If you explicitly use the \`-Cups\` parameters,
\`-Take\` is unnecessary.

You can optionally add the date, which default value is \`Now\`.
This is useful if you completed the action hours
or days ago, and are just remembering now.

## EXAMPLES

### EXAMPLE 1
```
Invoke-CoffeeTracker -Add 1 Dollar
```

Adds a dollar to the _Credit_ data of your tracker file.
Your balance will gain \`Amount/Cost\` cups.

### EXAMPLE 2
```
Invoke-CoffeeTracker -Take 2
```

Adds 2 cups to the _Debit_ data of your tracker file.
Your balance will drop by 2 cups.

### EXAMPLE 3
```
Invoke-CoffeeTracker -Amount 75 -Unit Cent -Date 07/04/1776
```

Adds 75 cents to the _Credit_ data of your tracker file.
Tags the date as July 4, 1776.
Your balance will gain
\`Amount/Cost\` cups.

### EXAMPLE 4
```
Invoke-CoffeeTracker -Cups 3
```

Adds 3 cups to the _Debit_ data of your tracker file.
Your balance will drop by 3 cups.

## PARAMETERS

### -Amount
The Amount added.

```yaml
Type: Double
Parameter Sets: Add
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unit
The Unit of the Amount added.

```yaml
Type: UnitCost
Parameter Sets: Add
Aliases:
Accepted values: Cent, Dollar

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cups
Number of Cups taken.

```yaml
Type: Int32
Parameter Sets: Take
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
The Date of the Action.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Add
A Switch to indicate you are adding an Amount and a Unit.

```yaml
Type: SwitchParameter
Parameter Sets: Add
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Take
A Switch to indicate you are taking a Cup.

```yaml
Type: SwitchParameter
Parameter Sets: Take
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Silent
Do not return the resulting Balance; no Report.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Shh, Z

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
