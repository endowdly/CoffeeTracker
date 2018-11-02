[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]

param (
    [switch] $Create,
    $Path
)

Enum UnitCost {
    Cent
    Dollar
}

$Default = @{
    Cost = 25
    Unit = [UnitCost]::Cent
    TrackerPath = $env:USERPROFILE
    TrackerName = "CoffeeTracker.json"
} 

$TemplateFile = Join-Path $PSScriptRoot CoffeeTracker.Template.psd1
$TemplateData = Import-PowerShellDataFile $TemplateFile

$CoffeeTrackerPath =
    if ($PSBoundParameters.ContainsKey("Path")) {
        if (Test-Path $Path) {
            return $Path
        }
    }
    else {
        Join-Path $Default.TrackerPath $Default.TrackerName
    }

# Source    
Join-Path $PSScriptRoot *.ps1 -Resolve | ForEach-Object { . $_ }

# Xeq 
if ($Create) {
    New-CoffeeTracker $CoffeeTrackerPath
}

Set-Alias Get-CoffeeBalance Read-CoffeeBalance