# Get vs. Read
# The Get verb is used to retrieve a resource, such as a file. The Read verb is used to get information from a source, such as a file.
# Source -> https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands

# Since we are technically _reading_ the balance from the tracker file, verb will be read.
# However, I expect people will want to use get. So, I will make an alias for Read- as Get-

# Starting in Windows PowerShell 5.0, Write-Host is a wrapper for Write-Information. 
# This allows you to use Write-Host to emit output to the information stream. 
# This enables the capture or suppression of data written using Write-Host while preserving backwards compatibility. 

function Read-CoffeeBalance {
    [CmdletBinding()]
    param (
        # Output "Beautifully". If you want to capture this to output, use -InfomrationVariable, -InformationAction, or redirect the number 6 stream to output: `6>&1`. 
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
            catch [System.Management.Automation.ItemNotFoundException], [System.IO.FileNotFoundException] {
                ThrowAFileFit
            }            
        }
        else {
            ThrowAFileFit
        }
    }
}