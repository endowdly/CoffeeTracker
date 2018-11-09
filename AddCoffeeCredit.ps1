    <#
    .Synopsis
        Adds credit Data to CoffeeTracker File.
    .Description
        Adds credit Data to CoffeeTracker File by reading the Json data, converting it to a PowerShell object,
        changing the data, converting it back to Json data, and resetting the file.
    .Example
        PS C:\> Add-CoffeeCredit -Amount 25 -Unit Cent
        Adds 25 Cents to the Tracker.Credit Data of CoffeeTracker File.
    #>
function Add-CoffeeCredit {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The Amount added to the Pot.
        [Parameter(Mandatory, Position=0)]
        [System.Double]
        $Amount,

        # The Unit of the Amount. Can be Dollar or Cent.
        [Parameter(Mandatory, Position=1)]
        [UnitCost]
        $Unit,

        # The Date of the Credit. Default: Now
        [Parameter(Position=2)]
        [System.DateTime]
        $Date = [System.DateTime]::Now,

        # No Report
        [Alias("Shh", "Z")]
        [switch]
        $Silent
    )
    
    begin {
        # Update the amount type based on the Unit
        $Amount = 
            switch ($Unit) {
                Dollar { $Amount -as [System.Double] }
                Cent { $Amount -as [System.Int32] }
            }

        $NewCredit = @{
            Amount = $Amount
            Unit = $Unit.ToString()
            Date = $Date.ToString('o') 
        }

        $Data = Get-Content $CoffeeTrackerPath | ConvertFrom-Json 
        Write-Verbose "Got content from $CoffeeTrackerPath"
    }
    
    process {
    }
    
    end {
        $Data.Tracker.Credit += $NewCredit

        # Update the balance, convert back into Json and set the File.
        if ($PSCmdlet.ShouldProcess("$CoffeeTrackerPath", "Adding data to file")) {
            Update-CoffeeTracker $Data |
            ConvertTo-Json -Depth 3 | 
            Set-Content $CoffeeTrackerPath -Encoding UTF8

            Write-Verbose "Updated $CoffeeTrackerPath"
            
            if (-not $Silent) {
                Read-CoffeeBalance -Pretty 
            }
        } 
    }
}