function Add-CoffeeDebit { 
    <#
    .Synopsis
        Add debit Data to CoffeeTracker File.
    .Description
        Adds credit Data to CoffeeTracker File by reading the Json data, converting it to a PowerShell object,
        changing the data, converting it back to Json data, and resetting the file.
    .Example
        PS C:\>  Add-CoffeeDebit -Cups 2
        Adds 2 Cups to the Tracker.Debit Data of CoffeeTracker File.
    #>
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