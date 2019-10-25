# > Get vs. Read
# :     The Get verb is used to retrieve a resource, such as a file. The Read verb is used to get information from a source, such as a file.
# -> https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands
# Since we are technically _reading_ the balance from the tracker file, verb will be read.

function Read-CoffeeBalance {
    <#
    .Synopsis
      Reads the final balance of a coffee tracker file.
    .Description
      Reads the final balance of a coffee tracker file.

      If the -Pretty switch is used, no output is sent to STDOUT. 
      Output is redirected to the Console and to stream 6. 
    .Example
      Read-CoffeeBalance
    .Example
      Read-CoffeeBalance -Pretty
    .Example
      Read-CoffeeBalance -Pretty -Path 'somecoffeefile.csv'
    .Inputs
      System.String
    .Outputs
      System.Int32
    .Notes
    #>

    [CmdletBinding()]

    param (
        # Output 'Beautifully'. If you want to capture this to output, use -InformationVariable, -InformationAction, or redirect the number 6 stream to output: `6>&1`. 
        [Parameter()]
        [Alias('ConsoleOutput')]
        [switch] $Pretty,

        # Specifies a path to one or more locations.
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('PSPath')]
        [ValidateScript({ Assert-Path $_ })]
        [string] $Path = $Default.TrackerPath
    )
    
    process {
        $data = Import-Csv $Path
                
        Write-Balance $data[-1].Balance -Pretty:$Pretty
    }
}