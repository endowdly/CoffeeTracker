<#
.Synopsis
    Initializes a new CoffeeTrackerFile
.Description
    This is really a fancy Wrapper for the New-Item Cmdlet.
.Example
    PS C:\> New-CoffeeTracker -Cost 25 -Unit Cent
    Creates a new File at the "~/CoffeeTracker.json" with a blank Tracker and the coffee Information as initialized.
#>
function New-CoffeeTracker { 
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "")]  # Handled by the wrapped Command
    [CmdletBinding(DefaultParameterSetName="PathSet", 
                   SupportsShouldProcess,
                   ConfirmImpact="Medium")]
    [OutputType([System.IO.FileInfo])]                   
    param (
        # The Path of the File or the its intended Directory. Default: USERPROFILE.
        [Parameter(ParameterSetName="PathSet", Position=0, ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName="NameSet", Position=0, ValueFromPipelineByPropertyName)]
        [System.String[]]
        $Path = $PWD,

        # The name of the File. Default: "CoffeeTracker.json"
        [Parameter(ParameterSetName="NameSet", Position=1, ValueFromPipelineByPropertyName)]
        [AllowNull()]
        [AllowEmptyString()]
        [System.String]
        $Name = "CoffeeTracker.json",

        # The unit Cost of the Coffee.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNull()]
        [System.Double]
        $Cost,

        # The unit of the coffee Cost. Can be Dollar or Cent.
        [Parameter(ValueFromPipelineByPropertyName)]
        [UnitCost]
        $Unit,

        # Force an existing File to be overwritten.
        [Switch]
        $Force 
    )
    
    begin {      
        # Copy the Template
        # Todo: Do not use Template, hardcode Hashtable here
        $NewData = $TemplateData.Clone()

        #region Set Missing Parameters
        # Todo: Define defaults in This.Param
        if (-not $PSBoundParameters.ContainsKey("Cost")) {
            $Cost = $Default.Cost
        }
        
        if (-not $PSBoundParameters.ContainsKey("Unit")) {
            $Unit = $Default.Unit
        } 
        #endregion 

        #region Update Values
        $Cost = 
            switch ($Unit) {
                Cent { $Cost -as [System.Int32] }
                Dollar { $Cost -as [System.Double] } 
            } 

        # Update the cloned template data with instance parameters
        $NewData.Coffee.Cost = $Cost
        $NewData.Coffee.Unit = $Unit.ToString() 
        $Value = ConvertTo-Json $NewData -Depth 3 

        # Cleanup PSBoundParameters so we can just use New-Item
        [void] $PSBoundParameters.Remove("Unit")
        [void] $PSBoundParameters.Remove("Cost")
        [void] $PSBoundParameters.Add("Value", $Value)
        #endregion

        try {
            # Ensure we don't call a user defined `New-Item`
            $WrappedCmd = $ExecutionContext.InvokeCommand.GetCmdlet("New-Item")
            $Cmd = { & $WrappedCmd -Type File @PSBoundParameters }
            $CmdPipeline = $Cmd.GetSteppablePipeline()
            [void] $CmdPipeline.Begin($PSCmdlet) 
        }
        catch {
            throw $_
        }
    }
    
    process {
        try {
            $CmdPipeline.Process($_)
        }
        catch {
           throw $_ 
        }
    }
    
    end {
        try {
            $CmdPipeline.End()
        }
        catch {
            throw $_ 
        }
    }
}