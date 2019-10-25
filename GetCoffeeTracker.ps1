function Get-CoffeeTracker {
    <#
    .Synopsis
      Fetches the coffee tracker file.
    .Description
      Fetches the coffee tracker file.
      The default behavior of this cmdlet is to get the FileInfo for the currently set default tracker file.
      A path can be passed or piped to specific tracker files.

      Command line switches can be used to specify specific behavior concerning this file:

      -Read can be used to provide the raw content of the file.
      -AsObject can be used to pass the Coffee[] object contained in the file.

      These are simple calls made to Get-Item, Get-Content, and Import-Csv.
      No validation occurs to ensure data types.
    .Example
      PS> Get-CoffeeTracker
    .Example
      PS> Get-CoffeeTracker -Raw
    .Example
      PS> Get-CoffeeTracker -AsObject
    .Example
      PS> 'file1.csv', 'file2.csv' | Get-CoffeeTracker -Read 
    .Inputs
      System.String
    .Outputs
      System.String[]
      Coffee[]
    .Notes
      Really should offer some kind of schema or validation to ensure these are the right data. 
    #>

    [CmdletBinding(DefaultParameterSetName='Default')]

    param (
        # Display the contents of the tracker file. Raw content.
        [Parameter(ParameterSetName='Raw')]
        [Alias('Raw')]
        [switch] $Read,

        # Display the contents of the tracker as an object.
        [Parameter(ParameterSetName='Object')]
        [switch] $AsObject,

        # Path to the tracker path. Default: Config.TrackerPath or 'Env:USERPROFILE/coffee.csv'.
        [Parameter(ValueFromPipeline)]
        [ValidateScript({ Assert-Path $_ })]
        [string] $Path = $Default.TrackerPath
    )

    switch ($PSCmdlet.ParameterSetName) {
        Raw { Get-Content $Path -Raw -Encoding UTF8 }
        Object { Import-Csv $Path | Format-Table }
        default { Get-Item $Path } 
    }
}