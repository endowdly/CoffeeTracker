﻿# CoffeeTracker
## about_CoffeeTracker

# SHORT DESCRIPTION
Track your ☕️

# LONG DESCRIPTION
Do you have a Community Pot at Work? Is it pay per Cup, like mine?
But, who always has a Quarter on them for one Cup!?
Do you sometimes lose track of what you have contributed and don't know if
you can pull another Cup of Joe?


With CoffeeTracker, you now can! 🕺


Initialize your CoffeeTracker with the cost of your coffee per cup in Dollars or Cents. Then, simply tell CoffeeTracker when you either `-Add` monies or `-Take` Coffees. You can then poll the tracker for your Coffee Cup balance.


CoffeeTracker uses json files to track how much 💰 you have dropped into the pot and how much coffee you have taken out of the pot.


You can initialize your json file in two ways:


1. On Module Load! The Module takes two arguments, `-Create` and `-Path`. Both are optional. `-Create` is a switch, so pass it `$true` if you want to create a CoffeeTracker.json file in the default location, your `$Home` folder. You can pass a fully resolved path with the second argument to set the initial path if you don't want to use the default location. You can also set `-Create` to `$false` and still change the default path. Examples below. 


2. With `New-CoffeeTracker`, which is just a fancy wrapper for `New-Item`. You can set your initial price with `-Cost` and `-Unit` (which can only be `Dollar` or `Cent`). 


# EXAMPLES
Import-Module CoffeeTracker -ArgumentList $true


Import-Module CoffeeTracker -ArugmentList $true, c:\Somewhere\else


Import-Module CoffeeTracker -ArgumentList $false, c:\MyCoffeeTracker.json


New-CoffeeTracker -Path C:\Somwhere -Cost 25 -Unit Cent


New-CoffeeTracker -Path $Home -Name TrackThatCoffee.json -Cost 1 -Unit Dollar


# NOTE
Note: you cannot set your initial price with from Module initialization! So you will have to go into your json file and manually edit that. Default values are `$false` and `$env:USERPROFILE/CoffeeTracker.json`.