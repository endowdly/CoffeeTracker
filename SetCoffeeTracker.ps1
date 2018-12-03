<#
.Synopsis
    Sets the Path of the CoffeeTracker File.
.Description
    Sets the Path of the CoffeeTracker File. Accepts wildcard input. Does not support literal Paths.
    Does not support multiple Paths.
.Example 
    PS C:\> Set-CoffeeTracker ~/.coffeetracker
    Sets the File named '.coffeetracker' in the Home Directory as the CoffeeTracker File to use.
.Inputs
    System.Object
        Can be a System.String descibing a Path or a System.IO.FileInfo object.
.Outputs
    System.Void
#>
function Set-CoffeeTracker {

    [CmdletBinding(SupportsShouldProcess)]
    param (
       # Specifies a Path to one Location. Wildcards are permitted.
       [Parameter(Position=0,
                  ValueFromPipeline,
                  ValueFromPipelineByPropertyName)]
       [AllowNull()]
       [AllowEmptyString()]
       [SupportsWildcards()]
       [System.String]
       $Path 
    )

    begin { 
        filter UpdatePath {
            Write-Verbose "CoffeeTrackerPath <- $_"
            $script:CoffeeTrackerPath = Resolve-Path $_
            return
        }

        function SetTrackerToDefault {
            Write-Verbose "-Path is null; using default TrackerPath" 
            Join-Path $Default.TrackerPath $Default.TrackerName | UpdatePath
        }

        function SetTrackerToPath {
            $Msg = $Path | Resolve-Path | Split-Path -Leaf
            
            if ($PSCmdlet.ShouldProcess("$Msg", "Updating CoffeeTracker Path")) {
                $Path | UpdatePath
            } 
        }
    }

    process { }
    
    end { 
        switch ($Path) {
            { $null -eq $Path } { SetTrackerToDefault }
            { [String]::IsNullOrEmpty($Path) } { SetTrackerToDefault }
            { [String]::IsNullOrWhiteSpace($Path) } { SetTrackerToDefault }
            { Test-Path $Path } { SetTrackerToPath }
            default { Write-Error "$Path is not a valid path or does not exist" -Category InvalidArgument }
        }
    }
}