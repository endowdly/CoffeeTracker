@{
    InvalidPath         = 'Invalid Path: {0} does not exist!'
    InvalidNumeric      = '{0} must be a number!'
    InvalidObject       = 'Not a Coffee Object!'

    InvokeCoffeeTracker = @{

        ShouldProcess = @{
            Action = 'Update coffee tracker file?'
        }

        Verbose       = @{
            Importing    = 'Got coffee tracker data from {0}.'
            DoesNotExist = 'Coffee tracker file {0} does not yet exist.'
            Balanced     = 'Balance updated.'
            Updated      = 'Coffee tracker file at {0} updated.'
        }

        Information   = @{
            Balance = 'New balance: {0} cups.'
        }
    }

    SetCoffeeTracker    = @{

        ShouldContinue = @{
            Query   = 'Update Default Coffee Tracker to {0}?'
            Caption = 'Confirm FilePath Overwrite'
        }
        
        Verbose        = @{
            Updating = 'Default Coffee Tracker <- {0}'
        }
    }
}