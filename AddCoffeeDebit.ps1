function Add-CoffeeDebit { 
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The amount of cups taken. Default: 1
        [Parameter(Position=0)]
        [System.Int32]
        $Cups = 1,

        # The Date of the taking: Default: Now
        [Parameter(Position=1)]
        [System.DateTime]
        $Date = [System.DateTime]::Now
    )
    
    begin {
        $NewDebit = @{
            Date = $Date.ToString('o') 
            Cups = $Cups 
        }

        $Data = Get-Content $CoffeeTrackerPath | ConvertFrom-Json
        Write-Verbose "Got content from $CoffeeTrackerPath"
    }
    
    process {
    }
    
    end {
        $Data.Tracker.Debit += $NewDebit
        # But it back into Json and set the File.
        if ($PSCmdlet.ShouldProcess("$CoffeeTrackerPath", "Adding data to file")) {
            Update-CoffeeTracker $Data |
            ConvertTo-Json -Depth 3 | 
            Set-Content $CoffeeTrackerPath -Encoding UTF8
        }

        Write-Verbose "Updated $CoffeeTrackerPath"
    }
}