function Invoke-CoffeeTracker {
    [CmdletBinding(DefaultParameterSetName="Add")]
    param (
        # The Amount added.
        [Parameter(ParameterSetName="Add", Position=0)]
        [AllowNull()]
        [System.Double]
        $Amount,

        # The Unit of the Amount added.
        [Parameter(ParameterSetName="Add", Position=1)]
        [AllowNull()]
        [UnitCost]
        $Unit,

        # Number of Cups taken.
        [Parameter(ParameterSetName="Take", Position=0)]
        [AllowNull()]
        [System.Int32]
        $Cups,

        # The Date of the Action.
        [Parameter()]
        [AllowNull()]
        [System.DateTime]
        $Date,

        [Parameter(ParameterSetName="Add")]
        [switch]
        $Add,

        [Parameter(ParameterSetName="Take")]
        [switch]
        $Take
    )
    
    begin {
        Write-Debug $PSCmdlet.ParameterSetName
    }
    
    process {
        switch ($PSCmdlet.ParameterSetName) {
            Add { 
                [void] $PSBoundParameters.Remove("Add")
                Add-CoffeeCredit @PSBoundParameters
            }
            Take {
                [void] $PSBoundParameters.Remove("Take")
                Add-CoffeeDebit @PSBoundParameters
            }
        }
    }
}