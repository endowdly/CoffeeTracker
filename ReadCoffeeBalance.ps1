# Get vs. Read
# The Get verb is used to retrieve a resource, such as a file. The Read verb is used to get information from a source, such as a file.
# Source -> https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands

# Since we are technically _reading_ the balance from the tracker file, verb will be read.
# However, I expect people will want to use get. So, I will make an alias for Read- as Get-

function Read-CoffeeBalance {
    <#
    .Synopsis
        Read the Coffee Balance from the Tracker File.
    .Description
        Read the Coffee Balance from the Tracker File.
    .Example
        PS C:\> Read-CoffeeBalance
        Return the balance as an integer of cups.
    .Example
        PS C:\> Read-CoffeeBalance -Pretty
        Return the balance as an integer of cups _beautifully_ (for the console).
    #>
    [CmdletBinding()]
    [Alias('Get-CoffeeBalance')]

    param (
        # Output 'Beautifully'. Capture this output with the Information Stream (PowerShell 5+)
        [Parameter()]
        [switch]
        [Alias('ConsoleOutput')]
        $Pretty
    )
    
    begin {
        $PathIsValid = Test-Path $CoffeeTrackerPath

        function ThrowAFileFit {
            $Msg = "No CoffeeTrackerFile found at $CoffeeTrackerPath! Use `Set-CoffeeTracker` to set a valid CoffeeTracker path."
            $Ex = New-Object System.IO.FileNotFoundException $Msg
            Write-Error -Exception $Ex -Category ObjectNotFound 
        }

        filter Prettify {
            if ($Pretty) {
                $Color = 
                    switch ($_) {
                        { $_ -eq 0 } { [ConsoleColor]::Blue }
                        { $_ -gt 0 } { [ConsoleColor]::Green }
                        { $_ -lt 0 } { [ConsoleColor]::Red }
                    }

                Write-Host "You have " -NoNewline
                Write-Host $_ -ForegroundColor $Color -NoNewline 
                Write-Host " cups of " -NoNewline
                Write-Host "coffee" -ForegroundColor White -NoNewline
                Write-Host " remaining."
            }
            else {
                Write-Output $_
            }
        }
    }

    end {
        if ($PathIsValid) {
            try {
                $Data = Get-Content $CoffeeTrackerPath | ConvertFrom-Json
                $Data.Balance | Prettify
            }
            catch {
                ThrowAFileFit   # Must be Json
            }            
        }
        else {
            ThrowAFileFit
        }
    }
}