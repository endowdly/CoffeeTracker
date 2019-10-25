<#
.Synopsis
  Manage a coffee pot from the commandline with PowerShell!
.Description
  Do you have a Community Pot at Work? Is it pay per Cup, like mine? But, who always has a Quarter on them for one Cup!? Do you sometimes lose track of what you have contributed and don't know if you can pull another Cup of Joe? 
  With CoffeeTracker, you now can! 🕺

  Initialize your CoffeeTracker with the cost of your coffee per cup in Dollars or Cents. Then, simply tell CoffeeTracker when you either `-Add` monies or `-Take` coffees. You can then poll the tracker for your Coffee Cup balance.


  Set the default tracker path on module load with a valid path or later on with the `Set-CoffeeTracker` command.
#>

param (
    [ValidateScript({ (Test-Path $_ -IsValid) -or $( throw "Invalid Path: $_" ) })]
    $Path = (Join-Path $env:USERPROFILE coffee.csv)
)

#region Setup ------------------------------------------------------------------

$ErrorActionPreference = 'Stop' 

$ModuleRoot = Split-Path $PSScriptRoot -Leaf
$ResourceFile = @{ 
    BindingVariable = 'Resources'
    BaseDirectory = $PSScriptRoot
    FileName = $ModuleRoot + '.Resources.psd1'
}
$ConfigFile = @{
    BindingVariable = 'Config'
    BaseDirectory = $PSScriptRoot
    FileName = $ModuleRoot + '.Config.psd1'
}

try {
    Import-LocalizedData @ResourceFile 
    Import-LocalizedData @ConfigFile
}
catch {
    Import-LocalizedData @ResourceFile -UICulture en-US

    $Config = @{
        Cost = 25
        CostUnit = 'Cent'
        TrackerPath = $Path
    }
}

#endregion

#region Module Types -----------------------------------------------------------

enum Unit {
    Cent
    Dollar
}

#endregion

#region Module Variables -------------------------------------------------------

$Default = @{ 
    Date        = [datetime]::Now
    Cost        = $Config.Cost
    CostUnit    = $Config.CostUnit -as [Unit]
    Amount      = 0
    AmountUnit  = [Unit]::Dollar
    Cups        = 0
    Balance     = 0
    TrackerPath = 
        if (!$Config.TrackerPath) {
            $Path
        }
        else {
            $Config.TrackerPath
        }
} 

#endregion

#region Module Functions -------------------------------------------------------


function New-CoffeeObject {
    # .Synopsis
    # Creates a new coffee object with default values for use in tracking coffee.

    [PSCustomObject]@{
        PSTypeName  = 'Coffee'
        Date        = $Default.Date
        Cost        = $Default.Cost
        CostUnit    = $Default.CostUnit
        AmountAdded = $Default.Amount
        AmountUnit  = $Default.AmountUnit 
        CupsTaken   = $Default.Cups
        Balance     = $Default.Balance 
    }
}


filter Set-CoffeeDate ([datetime] $dt) { $_.Date = $dt.ToString('o'); $_ }
filter Set-CoffeeCost ($n) { $_.Cost = $n; $_ }
filter Set-CoffeeCostUnit ([Unit] $s) { $_.CostUnit = $s; $_ }
filter Set-CoffeeAmount ($n) { $_.AmountAdded = $n; $_ }
filter Set-CoffeeAmountUnit ([Unit] $s) { $_.AmountUnit = $s; $_ }
filter Set-CoffeeCups ([int] $n) { $_.CupsTaken = $n; $_ }
filter Set-CoffeeBalance ([int] $n) { $_.Balance = $n; $_ }


function Get-Unit ($n) {
    # .Synopsis
    # Infers the unit type based on the type of the numeric.
    # If integer, assumes Cent. If floating point, assumes Dollar.

    if ($n -is [int]) {
        [Unit]::Cent
    }
    else {
        [Unit]::Dollar
    }
}


function Get-Amount ($x) { [float] $x.AmountAdded, [Unit] $x.AmountUnit }  # obj -> float * Unit
function Get-Cost ($x) { [float] $x.Cost, [Unit] $x.CostUnit }  # obj -> float * Unit


# float * Unit -> int 
function ConvertTo-Cent ($t) {
    # .Synopsis
    # Takes a 'tuple' representing an amount and its unit and converts it to cents if applicable.

    $n, $u = $t

    switch ($u) {
        Cent { $n -as [int] }
        Dollar { ($n * 100) -as [int] }
    } 
}


# Coffee -> int
filter Get-LineBalance {
    # .Synopsis
    # Calculates the balance of a coffee object.

    $cupDebit = [int] $_.CupsTaken
    $cost = ConvertTo-Cent (Get-Cost $_)
    $credit = ConvertTo-Cent (Get-Amount $_) 

    # Total cup credit will be credit divided by cost -- (amount ¢) / (amount ¢ / cup) = cups
    $cupCredit = $credit / $cost

    $cupCredit - $cupDebit  # line balance
}
    

# int[] -> int
function Get-Sum {
    begin { $acc = 0 }
    process { $acc += $_ }
    end { $acc } 
}


# Coffee[] -> int
function Get-Balance ($Data) {
    # .Synopsis
    # Updates the balance on a Coffee[]. Do this with a bookkeeping check. 

    $Data |
        Get-LineBalance |
        Get-Sum 
}


function Write-Balance ($n, $Pretty) {
    # .Synopsis
    # Shows a number as a balance. Can be pretty.

    $s = if ($n -eq 1) { '' } else { 's' }

    if ($Pretty) {
        $color = 
            switch ($n) {
                { $n -eq 0 } { [ConsoleColor]::Blue }
                { $n -gt 0 } { [ConsoleColor]::Green }
                { $n -lt 0 } { [ConsoleColor]::Red }
            }

        Write-Host 'You have ' -NoNewline
        Write-Host $n -ForegroundColor $color -NoNewline 
        Write-Host " cup$s of " -NoNewline
        Write-Host 'coffee' -ForegroundColor White -NoNewline
        Write-Host ' remaining.'
    }
    else {
        Write-Output $n
    }
}

#region Gatekeeping ------------------------------------------------------------


function Assert-Path ($s) {
    # .Synopsis
    # Bails on a bad path.
    # Should only be used in a ValidateScript block.

    if (Test-Path $s) {
        $true
    }
    else {
        throw ($Resources.InvalidPath -f $s)
    } 
}


function Assert-Numeric ($n) {
    # .Synopsis
    # Bails if n is not a number. Must be a non-negative number.
    # Should only be used in a ValidateScript block.

    $isNumeric = [float]::TryParse($n, [ref] $null) 

    if ($isNumeric) {
        $true
    }
    else {
        throw ($Resources.InvalidNumeric -f $n) 
    }
}


#endregion

# Source    
Join-Path $PSScriptRoot *.ps1 -Resolve | ForEach-Object { . $_ }
