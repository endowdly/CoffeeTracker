<# 
                                        !!! Warning !!! 
        This file is meant to be used as a template. Do not change or edit this file!

    Note:
        Until a Export-PowerShellDataFile or ConvertTo-PowerShellData is a built-in thing, we will use Json. There
        is built-in Json support as of PowerShell 3.0+. You would think importing and exporting type-safe psd1 
        files would be a priority for PowerShell... 

        This data is converted to Json to store data.... until I make a good psd1 De/Serializer. I would have used
        CliXml, however I would like the file to be slightly more readable and modifiable. 
#>

@{
    # CoffeeTracker

    # AutoGen
    Balance = 0   # This is the balance in coffees. It is updated whenever tracker is updated from a function.

    # This is how much the coffee costs. Cost must be an integer or float value. Unit must be 'Dollar', or 'Cent'.
    Coffee = @{
        Cost = ""
        Unit = ""
    }

    Tracker = @{
        # Also Generated by Add-CoffeeCredit
        Credit = @(
            @{
                Date   = ""   # Should be in a format that can be converted to a DateTime object, e.g., 2018-10-22T12:01:15.6201040-04:00
                Amount = ""   # How much you put in the pot in ...
                Unit   = ""   # Dollars or Cents
            }
        )

        # Also Generated by Add-CoffeeDebit
        Debit = @(
            @{ 
                Date = ""   # See above
                Cups = 0    # How much did you drink?
            }
        )
    }
}