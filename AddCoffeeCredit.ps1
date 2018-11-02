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
        $Date = [System.DateTime]::Now 
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
        }

        Write-Verbose "Updated $CoffeeTrackerPath"
    }
}