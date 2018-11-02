function Update-CoffeeTracker {
    <#
    .SYNOPSIS
        Updates the balance of the current Tracker File.
    .DESCRIPTION
        Updates the balance of the current Tracker File. When called, it calculates the current balance from the 
        data available in the Coffee and Tracker data.
    .EXAMPLE
        PS C:\> Update-CoffeeTracker
        The only way it can be used.
    #>
    [CmdletBinding()]
    param (
        # The Data to Update. Should be a PSObject.
        [Parameter(Mandatory)]
        $Data
    )

    begin { 
        function SimpleSum {
            begin { $a = 0 }
            process { $a += $_ }
            end { $a } 
        } 

        filter CostToCents {
            $x = $_
            switch ($x.Unit) {
                Cent { $x.Cost }
                Dollar { ($x.Cost * 100) -as [System.Int32] }
            }
        }

        filter AmountToCents {
            $x = $_ 
            switch ($x.Unit) {
                Cent { $x.Amount }
                Dollar { ($x.Amount * 100) -as [System.Int32] }
            }
        }

        $Tags = @(
            $MyInvocation.MyCommand.Name
            "End"
            "Data"
        )
    }
   
    end {
        Write-Information "Current Balance: $( $Data.Balance ) cups" -Tags $Tags

        $CupDebit = $Data.Tracker.Debit.Cups | SimpleSum
        
        # To keep it simple, we will push everything to cents.
        $Cost = $Data.Coffee | CostToCents
        $Credit = $Data.Tracker.Credit | AmountToCents | SimpleSum

        Write-Information "Cost: $Cost cents" -Tags $Tags
        Write-Information "Total Credit: $Credit cents" -Tags $Tags

        $CupCredit = $Credit / $Cost 
        $Balance = $CupCredit - $CupDebit

        Write-Information "New Balance: $Balance cups" -Tags $Tags        
        
        $Data.Balance = $Balance 

        Write-Verbose "Balance Updated"

        $Data   # return
    }
}