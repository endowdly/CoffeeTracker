function Set-CoffeeTracker {
    <#
    .Synopsis
        Sets the path of the CoffeeTracker file.
    .Description
        Sets the path of the CoffeeTracker file. Accepts wildcard input. Does not support literal paths.
        Does not support multiple paths.
    .Example 
        Pending
    .Inputs
        System.Object
            Can be a System.String descibing a path or a System.IO.FileInfo object.
    .Outputs
        System.Void
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
       # Specifies a path to one locations. Wildcards are permitted.
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
            if ($PSCmdlet.ShouldProcess($Msg)) {
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