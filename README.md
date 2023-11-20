# Pockest Care Scheduler

## What is this?

This is an [AutoHotkey](https://www.autohotkey.com/) script that automatically cares for [Street Fighter Pockest Monsters](https://www.streetfighter.com/6/buckler/minigame).

It does this by systematically clicking the specified care options (FOOD, CURE, CLEAN) and then will attempt to TRAIN a specified skill (Power, Speed, or Technique) according to the designated care plan. Default care plans are based on the [Pockest Guide on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=3003515624), but are totally customizable.

## How do I use it?

#### Download & Installation

1. [Download and install AutoHotkey v2](https://www.autohotkey.com/download/ahk-v2.exe).
2. [Download this repo](https://github.com/folklorelabs/pockest-care-scheduler/archive/refs/heads/main.zip).

#### Configure

1. Modify the PockestAutoCare.ini config file to your liking (see Config section below).

#### Run

1. Open https://www.streetfighter.com/6/buckler/minigame in a separate Chrome window.\*
2. Run **PockestAutoCare.ahk**.
3. Press **SHIFT + F12** to toggle the script on/off.

*\* This script depends on window sizing/positioning. Ensure you are using ***Chrome with the bookmarks bar visible***. Otherwise you will need to modify the Size, CanvasX, and CanvasY Settings within PockestAutoCare.ini to match the dimensions of your setup.*


## Config

#### \[CARE_PLAN\]
Care plan settings. Utilize [Pockest Guide on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=3003515624) to figure out which stats to train and which path to target specific characters.

![A tree of Pockest evolutionary paths. After age 2 (0d 12:00:00), the tree splits into 3 branches (A, B, and C). After age 3 (1d 12:00:00), the tree splits again with each letter splitting into its own L and R branches.](https://steamuserimages-a.akamaihd.net/ugc/2233283241947427052/827EBBB3FA1C8E3B98E94551F18476DF03DE069E/)

- **DateOfBirth**: The timestamp your Pockest was born in **YYYYMMDDHHmm** format where YYYY = year, MM = month (01-12), DD = day (01-31), HH = hour (00-23), mm = minute (00-59). Example: November 15, 2023 5:01 PM would be 202311151701.
    - Default: \[time of script execution\]
    - Type: Number
- **Divergence1**: The "Age 3" path divergence as specified in the "Evolutionary Paths" section of the [Pockest Guide](https://steamcommunity.com/sharedfiles/filedetails/?id=3003515624#6460421).
    - Default: "C"
    - Type: String ("A", "B", "C")
- **Divergence2**: The "Age 4" path divergence as specified in the "Evolutionary Paths" section of the [Pockest Guide](https://steamcommunity.com/sharedfiles/filedetails/?id=3003515624#6460421).
    - Default: "R"
    - Type: String ("L", "R")
- **Stat**: The stat with which to train the Pockest.
    - Default: "P"
    - Type: String ("P", "S", "T")

#### \[SETTINGS\]
General settings used by the script. Defaults should be good for most users here.

- **WindowTitle**: The title of the window containing the Pockest game. This is used by the script to focus and resize the window. You may need to change this if using a different language.
    - Default: "Pockest | Buckler's Boot Camp | STREET FIGHTER 6 | CAPCOM"
    - Type: String
- **Size**: The size of the Pockest canvas within the browser window. Used for calculating click positions.
    - Default: 302
    - Type: Number
- **CanvasX**: The x-offset of the Pockest canvas within the browser window. Used for calculating click positions.
    - Default: 333
    - Type: Number
- **CanvasY**: The y-offset of the Pockest canvas within the browser window. Used for calculating click positions.
    - Default: 443
    - Type: Number

#### \[PLAN_*\]
Settings to determine the different care plans available. Defaults should be good for most users here.

- **FeedTarget**: The target feed value (number of hearts) to train at each FeedFrequency.
    - Default: 0
    - Type: Number
- **FeedFrequency**: The frequency with which to feed the Pockest (in hours). Use a value of 0 to skip feeding. Example: a value of 12 would mean the script will feed every 12 hours.
    - Default: 0
    - Type: Number
- **CleanFrequency**: The frequency with which to clean the Pockest (in hours). Use a value of 0 to skip cleaning. Example: a value of 12 would mean the script will clean every 12 hours.
    - Default: 0
    - Type: Number
- **TrainFrequency**: The frequency with which to train the Pockest (in hours). Use a value of 0 to skip training. Example: a value of 12 would mean the script will train every 12 hours.
    - Default: 0
    - Type: Number
- **CureFrequency**: The frequency with which to cure the Pockest (in hours). Use a value of 0 to skip curing. Example: a value of 12 would mean the script will cure every 12 hours.
    - Default: 0
    - Type: Number

#### \[ROUTE_*\]
Settings to determine which plan to use at which age. Defaults should be good for most users here.

- **Age1**: The plan name to use when the Pockest is younger than 0d 01:00:00.
    - Type: String ("PLAN_LEFT", "PLAN_MID", "PLAN_RIGHT")
- **Age2**: The plan name to use when the Pockest is younger than 0d 12:00:00.
    - Type: String ("PLAN_LEFT", "PLAN_MID", "PLAN_RIGHT")
- **Age3**: The plan name to use when the Pockest is younger than 1d 12:00:00.
    - Type: String ("PLAN_LEFT", "PLAN_MID", "PLAN_RIGHT")
- **Age4**: The plan name to use when the Pockest is younger than 3d 00:00:00.
    - Type: String ("PLAN_LEFT", "PLAN_MID", "PLAN_RIGHT")
- **Age5**: The plan name to use when the Pockest is younger than 7d 00:00:00.
    - Type: String ("PLAN_LEFT", "PLAN_MID", "PLAN_RIGHT")