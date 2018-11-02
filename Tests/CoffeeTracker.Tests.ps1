Import-Module CoffeeTracker -Force
$ModuleManifestName = "CoffeeTracker.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

$OriginalPath = Get-CoffeeTracker

Describe "Module Manifest Tests" {
    It "Passes Test-ModuleManifest" {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe "New-CoffeeTracker" {
    InModuleScope CoffeeTracker {
        $DrivePath = "TestDrive:\"
        $Path = Join-Path $DrivePath test.json
        $InvalidPath = "This:\Does\not\exist.json"
        $ExpectedCost = 25
        $ExpectedUnit = [UnitCost]::Cent
        $Valid = @{
            Cost = $ExpectedCost
            Unit = $ExpectedUnit
            Path = "TestDrive:\"
            Name = "test.json"
        }
        
        It "Given valid Parameters, creates a Data File" {
            New-CoffeeTracker @Valid
            $Path | Should Exist
        }

        It "Given a valid piped -Path, creates a Data File" {
            $PipedPath = 'TestDrive:\test2.json'
            $PipedPath | New-CoffeeTracker -Path { $_ } -Cost 25 -Unit Cent
            $PipedPath | Should Exist
        }

        It "Given an invalid -Path, do nothing (but complain about the Path)" {
            New-CoffeeTracker $InvalidPath -ErrorAction SilentlyContinue
            $InvalidPath | Should Not Exist 
        }

        It "Given an invalid piped -Path, do nothing (but complain about the Path)" {
            $InvalidPath | New-CoffeeTracker -Path { $_ } -ErrorAction SilentlyContinue
            $InvalidPath | Should Not Exist 
        }
        It "In a created file, <Data> should be <Expected>" -TestCases @(
            @{ Data = "Cost"; Expected = $ExpectedCost }
            @{ Data = "Unit"; Expected = $ExpectedUnit }
        ) {
            param ($Data, $Expected)
            $File = Get-Content $Path | ConvertFrom-Json
            $File.Coffee.$Data | Should BeExactly $Expected
        }   

        It "Defaults to the correct Path given an empty -Name" -Pending {

        }
    }
}

Describe "Set-CoffeeTracker" {

    InModuleScope CoffeeTracker {
        $DefaultPath = Join-Path $Default.TrackerPath $Default.TrackerName 
        $InvalidPath = "This:\is\a\path\to\nowhere.json"
        $Path = Split-Path $PSScriptRoot -Parent | Join-Path -ChildPath CoffeeTracker.Template.psd1 
        Mock Write-Error { } 

        AfterEach {
            $Script:CoffeeTrackerPath = $DefaultPath
        }

        # Not sure how to check this because the default won't exist until the module is used...
        It "Given a null -Path, sets the module Variable 'CoffeeTrackerPath' to its default value" -Pending {
            Set-CoffeeTracker
            $CoffeeTrackerPath | Should Be $DefaultPath
        }

        It "Given a valid -Path, sets the module Variable 'CoffeeTrackerPath'" {
            Set-CoffeeTracker $Path
            $CoffeeTrackerPath | Should Be $Path
        }

        # Need to check to ensure CoffeeTrackerPath does not change, but that seems hard to do without exposing the variable
        It "Given a invalid -Path, does nothing (but complain about the Path)" {
            Set-CoffeeTracker $InvalidPath -ErrorAction SilentlyContinue
            Assert-MockCalled Write-Error
            #$CoffeeTrackerPath | Should Be $DefaultPath
        }
    } 
}

Describe "Add-CoffeeDebit" {
    InModuleScope CoffeeTracker {

        $Path = "TestDrive:\test.json"
        New-CoffeeTracker $Path | Set-CoffeeTracker 

        $CupTests = @(
            @{ P = "Foo"; R = "Throw" }
            @{ P = "3"; R = "Not Throw" }
            @{ P = "3.0"; R = "Not Throw" }
            @{ P = "3.3"; R = "Not Throw" }  # Should floor to 3
        )

        $DateTests = @(
            @{ P = "10/31/2043"; R = "Not Throw" }
            @{ P = "Foo"; R = "Throw" }
            @{ P = "March 3, 2018"; R = "Not Throw" }
            @{ P = "Bork"; R = "Throw" }
            @{ P = "2018-10-25T08:16:14.1138225-04:00"; R = "Not Throw" }
        )

        It "Given -Cups <P>, Should <R>" -TestCases $CupTests {
            param ($P, $R)
            switch ($R) {
                "Throw" { 
                    { Add-CoffeeDebit $P } | Should Throw
                }
                "Not Throw" { 
                    { Add-CoffeeDebit $P } | Should Not Throw
                }
            } 
        }

        It "Given -Date <P>, Should <R>" -TestCases $DateTests {
            param ($P, $R)
            switch ($R) {
                "Throw" { 
                    { Add-CoffeeDebit -Date $P } | Should Throw
                }
                "Not Throw" { 
                    { Add-CoffeeDebit -Date $P } | Should Not Throw
                }
            } 
        }

        It "Given valid Parameters, updates the CoffeeTracker" {
            $Date = Get-Date -Date 7-4-1776
            $Filter = {
                if (-not [String]::IsNullOrWhiteSpace($_.Date)) {
                    [datetime]$_.Date -eq $Date
                }
            }

            Add-CoffeeDebit 13 -Date $Date
            $Data = Get-Content $Path | ConvertFrom-Json
            $Freedom = $Data.Tracker.Debit | Where-Object $Filter
            $Freedom.Cups | Should BeExactly 13
        } 
    }
}

Describe "Add-CoffeeCredit" {
    InModuleScope CoffeeTracker {

        $Path = "TestDrive:\test.json"
        New-CoffeeTracker $Path | Set-CoffeeTracker 

        $AmountUnitTests = @(
            @{ Amount = "23.13"; Unit = "Dollar"; Result = "Not Throw" }
            @{ Amount = "23.13"; Unit = "Cent"; Result = "Not Throw" }    # Should floor to 23
            @{ Amount = "23"; Unit = "Cent"; Result = "Not Throw" }
            @{ Amount = "23"; Unit = "Dollar"; Result = "Not Throw" }    # Should cast
            @{ Amount = "Foo"; Unit = "Dollar"; Result = "Throw" }
            @{ Amount = "25"; Unit = "Bar"; Result = "Throw" }
        )

        $DateTests = @(
            @{ Amount = 25; Unit = "Cent"; Date = "10/31/2043"; Result = "Not Throw" }
            @{ Amount = 25; Unit = "Cent"; Date = "Foo"; Result = "Throw" }
            @{ Amount = 25; Unit = "Cent"; Date = "March 3, 2018"; Result = "Not Throw" }
            @{ Amount = 25; Unit = "Cent"; Date = "Bork"; Result = "Throw" }
            @{ Amount = 25; Unit = "Cent"; Date = "2018-10-25T08:16:14.1138225-04:00"; Result = "Not Throw" }
        )

        It "Given -Amount <Amount> and -Unit <Unit>, Should <Result>" -TestCases $AmountUnitTests {
            param ($Amount, $Unit, $Result)
            switch ($Result) {
                "Throw" { 
                    { Add-CoffeeCredit $Amount $Unit } | Should Throw
                }
                "Not Throw" { 
                    { Add-CoffeeCredit $Amount $Unit } | Should Not Throw
                }
            } 
        }

        It "Given -Date <Date>, Should <Result>" -TestCases $DateTests {
            param ($Amount, $Unit, $Date, $Result)
            switch ($Result) {
                "Throw" { 
                    { Add-CoffeeCredit $Amount $Unit -Date $Date } | Should Throw
                }
                "Not Throw" { 
                    { Add-CoffeeCredit $Amount $Unit -Date $Date } | Should Not Throw
                }
            } 
        }

        It "Given valid Parameters, updates the CoffeeTracker" {
            $Date = Get-Date -Date 7-4-1776
            $Unit = [UnitCost]::Cent
            $Filter = {
                if (-not [String]::IsNullOrWhiteSpace($_.Date)) {
                    [datetime]$_.Date -eq $Date
                }
            }

            Add-CoffeeCredit -Amount 13 -Unit $Unit -Date $Date
            $Data = Get-Content $Path | ConvertFrom-Json
            $Freedom = $Data.Tracker.Credit | Where-Object $Filter
            $Freedom.Amount | Should BeExactly 13
            $Freedom.Unit | Should BeExactly $Unit.ToString()
        } 
    }
}

Describe "Invoke-CoffeeTracker" { 
    InModuleScope CoffeeTracker {
        Mock Add-CoffeeCredit { }
        Mock Add-CoffeeDebit { }

        $InvokeTests = @(
            @{ Params = @{ Amount = 23; Unit = "Cent" }; Command = "Add-CoffeeCredit" }
            @{ Params = @{ Cup = 3 }; Command = "Add-CoffeeDebit" }
        )

        It "Given valid Parameters, executes <Command>" -TestCases $InvokeTests {
            param($Params, $Command)

            Invoke-CoffeeTracker @Params 
            Assert-MockCalled $Command
        }
    }
}

Describe "Update-CoffeeTracker" {
    InModuleScope CoffeeTracker { 

        function GetBalance { 
            $Data = Get-Content $Path | ConvertFrom-Json
            $Data.Balance
        }

        $Path = "TestDrive:\test.json"
        It "On call, it updates the balance of the set CoffeeTracker correctly" {
            New-CoffeeTracker $Path -Cost 1 -Unit Dollar | Set-CoffeeTracker
            GetBalance | Should BeExactly 0
            Add-CoffeeCredit 1 Dollar
            GetBalance | Should BeExactly 1
            Add-CoffeeDebit 1
            GetBalance | Should BeExactly 0 
        }
    }
}

Describe "Read-CoffeeBalance" { 
    $Path = "TestDrive:\test.json"
    New-CoffeeTracker $Path -Cost 25 -Unit Cent | Set-CoffeeTracker 
    Invoke-CoffeeTracker -Add 1 Dollar

    It "Returns the proper Balance" {
        Read-CoffeeBalance | Should BeExactly 4
    }
}

Describe "Get-CoffeeTracker" {

    It "Returns the current CoffeeTrackerFile Path" {
        $Path = "TestDrive:\test.json"
        New-CoffeeTracker $Path -Cost 25 -Unit Cent | Set-CoffeeTracker 

        Get-CoffeeTracker | Should Be (Convert-Path $Path)
    }
}

Set-CoffeeTracker $OriginalPath