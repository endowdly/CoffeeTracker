function Invoke-CoffeeTracker {
    <#
    .Synopsis
        The main function to change your CoffeeTracker File!
    .Description
        The **Invoke-CoffeeTracker** cmdlet is a wrapper to functions that manipulate the credit and debit data stored
        in your CofeeTracker File. You can `-Add` or `-Take` Coffee from the pot. When you _take_, you denote the action
        in cups of cofee. When you _add_, you denote the action in amount of money added to the pot. If you explicitly
        use the `-Amount` and `-Unit` parameters, `-Add` is unnecessary. If you explicitly use the `-Cups` parameters,
        `-Take` is unnecessary.

        You can optionally add the date, which default value is `Now`. This is useful if you completed the action hours
        or days ago, and are just remembering now.
    .Example
        PS C:\> Invoke-CoffeeTracker -Add 1 Dollar
        Adds a dollar to the _Credit_ data of your tracker file. Your balance will gain `Amount/Cost` cups.
    .Example
        PS C:\> Invoke-CoffeeTracker -Take 2
        Adds 2 cups to the _Debit_ data of your tracker file. Your balance will drop by 2 cups.
    .Example
        PS C:\> Invoke-CoffeeTracker -Amount 75 -Unit Cent -Date 07/04/1776
        Adds 75 cents to the _Credit_ data of your tracker file. Tags the date as July 4, 1776. Your balance will gain
        `Amount/Cost` cups.
    .Example
        PS C:\> Invoke-CoffeeTracker -Cups 3
        Adds 3 cups to the _Debit_ data of your tracker file. Your balance will drop by 3 cups.
    #>
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