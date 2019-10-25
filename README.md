# CoffeeTracker ☕️

Do you have a Community Pot at Work? Is it pay per Cup, like mine? But, who always has a Quarter on them for one Cup!? Do you sometimes lose track of what you have contributed and don't know if you can pull another Cup of Joe?

With CoffeeTracker, you now can! 🕺

Simply tell CoffeeTracker when you either `-Add` monies or `-Take` Coffees (or both). You can then poll the tracker for your _Coffee Cup_ balance.

## How

CoffeeTracker uses csv files to track how much 💰 you have dropped into the pot and how much coffee you have taken out of the pot.

Your file auto intializes on first use of `Invoke-CoffeeTracker` to a default location you can set on module load or with `Set-CoffeeTracker`.

### Examples

```powershell
Import-Module CoffeeTracker -ArgumentList h:\myCoffee.csv   # I already have a file here
Invoke-CoffeeTracker -Add 2.00 -Take 1                      # Adds $2.00 and takes 1 cup at 25 cents
```

You can create as many trackers as you'd like. This can be useful if you have two different pots.

You can set the current default tracker with `Set-CoffeeTracker`.
Every command has the ability to use a specific tracker with the `-Path` parameter.

## What

Windows PowerShell 3.0+. I don't see why this wouldn't necessarily work with PowerShell Core, but I haven't really looked at it or tested it.

Feel free to send Suggestions/Contributions. Just send your pull request or create your issue. :)

<!-- markdownlint-disable no-trailing-punctuation -->

## New!

This is Version 2.0, which is major breaking change!

### What's New?

- Drop JSON for flattened CSV transaction record 😮
- Entries are now object based (Coffee objects)
- Entries are now just trips to the pot and can be credits, debits, or both!
- More reliance on `Invoke-CoffeeTracker`

### How to I convert or Upgrade?

Well, I sincerly doubt anyone is actually using this besides me.
But if someone is, there is a simple conversion script I wrote that will load your old, JSON based coffee record and convert each entry into a Coffee object.
It will then list those object together, recalculate the balance, and then export it to the new data format.
You can then use the module as normal.
If this is ever of interest, let me know and I can add it.
