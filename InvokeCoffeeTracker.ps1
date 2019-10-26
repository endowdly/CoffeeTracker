function Invoke-CoffeeTracker {
    <# 
    .Synopsis
        Manages coffee transactions and records data to the coffee tracker.
    .Description
        Manages coffee transactions and records data to the coffee tracker.
        Allows the user to create a transaction recording a debit, credit, or both to a tracker file.
        This cmdlet loads the data from a tracker file, creates a new entry based on passed parameters, 
          uses the totality of data to determine an overall balance, and appends that entry to the tracker file. 

        This cmdlet focuses on ease of use and uses natural language processing in the command line.
        
        If explicit units are not used for the amount added or the cost of a cup, this function infers that unit
          from the type given. 
        For instance: an amount added to the pot is 50 and no unit is given. 
        The function will determine, because an integer was passed, the unit is Cent(s).
        To add fifty dollars, pass a floating point number, i.e., 50.0 or pass the AmountUnit 'Dollar'.

        Because adding amounts will be more common than a cost change, the add parameters are positionally first.
        Things like 'coffeepot -add 2 dollars' are possible. 
        For this to work best, always add before taking.
        You can take first, but then parameters cannot be positional. 

        This follows natural langauage processing schemes. See the examples for information.
    .Example
        PS> Invoke-CoffeeTracker -Take 1
        # Subtracts one cup at the given cost from the last balance. 
    .Example
        PS> Invoke-CoffeeTracker -Add 25
        # Makes a credit transaction of 25 cents. 
    .Example
        PS> Invoke-CoffeeTracker -Add 5 Dollar 
    .Example
        PS> Invoke-CoffeeTracker -Add 2.25
        # Implicitly adds 2 dollars and 25 cents.
    .Example 
        PS> Invoke-CoffeeTracker -Add 101 Cent -Take 2 -Cost 50 -CostUnit Cent
    .Example 
        PS> Invoke-CoffeeTracker -Take 2 -Add 1 -Unit Dollar
        # Taking first requires explicit parameters to be used.
    .Inputs
        None
    .Outputs
        Coffee
    .Notes 
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Coffee, CoffeePot')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]

    param (
        # The amount added.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [ValidateScript({ Assert-Numeric $_ })]
        [AllowNull()]
        $Add,

        # The unit of the amount added. Inferred if null.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [Alias('Unit')]
        [Unit] $AmountUnit,

        # Number of coffee cups taken.
        [Parameter(ValueFromPipelineByPropertyName, Position=2)]
        [System.Int32] $Take,

        # The date of the action.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.DateTime] $Date = [datetime]::Now,

        # The coffee cost. Default: Config.Cost.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateScript({ Assert-Numeric $_ })]
        $Cost = $Default.Cost,

        # The coffee cost unit. Inferred if not used.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Unit] $CostUnit,

        # No reporting to console.
        [Alias('Shh', 'Z') ]
        [switch] $Silent,

        # Return the added coffee object.
        [switch] $PassThru,

        # Specifies a path to a specific tracker file. Default: Config.TrackerPath or 'Env:USERPROFILE/coffee.csv'.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [ValidateScript({ Assert-Path $_ })]
        [string] $Path = $Default.TrackerPath
    )

    Write-Debug $PSCmdlet.ParameterSetName

    if (-not $PSBoundParameters.ContainsKey('CostUnit')) {
        $CostUnit = Get-Unit $Cost 
    }

    if (-not $PSBoundParameters.ContainsKey('AmountUnit')) {
        $AmountUnit = Get-Unit $Add
    }

    $data = @()
    $data += 
        try {
            Import-Csv $Path -Encoding UTF8
            Write-Verbose ($Resources.InvokeCoffeeTracker.Verbose.Importing -f $Path)
        }
        catch {
            Write-Verbose ($Resources.InvokeCoffeeTracker.Verbose.DoesNotExist -f $Path)
        } 
    
    $newEntry = 
        New-CoffeeObject |
            Set-CoffeeDate $Date | 
            Set-CoffeeCost $Cost |
            Set-CoffeeCostUnit $CostUnit |
            Set-CoffeeAmount $Add | 
            Set-CoffeeAmountUnit $AmountUnit | 
            Set-CoffeeCups $Take 

    $balance = Get-Balance ($data + $newEntry)

    Write-Verbose $Resources.InvokeCoffeeTracker.Verbose.Balanced
    Write-Information ($Resources.InvokeCoffeeTracker.Information.Balance -f $balance)
    
    if ($PSCmdlet.ShouldProcess($Path, $Resources.InvokeCoffeeTracker.ShouldProcess.Action)) {
        $newEntry |
            Set-CoffeeBalance $balance | 
            Export-Csv -Path $Path -Append -Encoding UTF8

        Write-Verbose ($Resources.InvokeCoffeeTracker.Verbose.Updated -f $Path)
    }

    if (-not $Silent) {
        Read-CoffeeBalance -Pretty
    }

    if ($PassThru) {
        $newEntry
    }
}