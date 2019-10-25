function Set-CoffeeTracker {
    <#
    .Synopsis
        Sets the path of the CoffeeTracker file.
    .Description
        Sets the path of the default CoffeeTracker file. This function will confirm you want to do this. 
        Does not support literal paths. Does not support multiple paths.
    .Example 
        PS> Set-CoffeeTracker h:/.myCoffee
    .Inputs
        System.String
    .Outputs
        None
    #>

    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '')]  # Yes it does? 

    param ( 
       # Specifies a path to one location. Wildcards are not permitted.
       [Parameter(Mandatory,
                  ValueFromPipeline,
                  ValueFromPipelineByPropertyName,
                  HelpMessage='Path to a location.')]
       [ValidateScript({ Assert-Path $_ })]
       [System.String] $Path,

       [switch] $Force
    )

    $fp = Resolve-Path $Path
    $q = $Resources.SetCoffeeTracker.ShouldContinue.Query -f $fp
    $c = $Resources.SetCoffeeTracker.ShouldContinue.Caption

    if ($PSCmdlet.ShouldContinue($q, $c) -or $Force) {
        Write-Verbose ($Resources.SetCoffeeTracker.Verbose.Updating -f $fp)

        $Default.TrackerPath = $fp
    }
}
