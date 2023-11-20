#Requires AutoHotkey v2.0
#SingleInstance

ConfigFile := "./PockestCareScheduler.ini"
CareDelay := 60000
DefaultSize := 301
MaxFeed := 6
ScriptId := RandomId(5)

; read config section - SETTINGS
Debug := IniRead(ConfigFile, "SETTINGS", "Debug", "True") = "True"
WindowTitle := IniRead(ConfigFile, "SETTINGS", "WindowTitle", "Pockest | Buckler's Boot Camp | STREET FIGHTER 6 | CAPCOM")
Size := IniRead(ConfigFile, "SETTINGS", "Size", DefaultSize)
CanvasX := IniRead(ConfigFile, "SETTINGS", "CanvasX", 333)
CanvasY := IniRead(ConfigFile, "SETTINGS", "CanvasY", 444)

; read config section - CARE_PLAN
DateOfBirth := IniRead(ConfigFile, "CARE_PLAN", "DateOfBirth", A_Now)
Divergence1 := IniRead(ConfigFile, "CARE_PLAN", "Divergence1", "C")
Divergence2 := IniRead(ConfigFile, "CARE_PLAN", "Divergence2", "R")
Stat := IniRead(ConfigFile, "CARE_PLAN", "Stat", "")

; read config section - ROUTE
RoutePlan := Map()
RoutePlan["Age1"] := IniRead(ConfigFile, "ROUTE_" Divergence1 Divergence2, "Age1")
RoutePlan["Age2"] := IniRead(ConfigFile, "ROUTE_" Divergence1 Divergence2, "Age2")
RoutePlan["Age3"] := IniRead(ConfigFile, "ROUTE_" Divergence1 Divergence2, "Age3")
RoutePlan["Age4"] := IniRead(ConfigFile, "ROUTE_" Divergence1 Divergence2, "Age4")
RoutePlan["Age5"] := IniRead(ConfigFile, "ROUTE_" Divergence1 Divergence2, "Age5")

WriteLog(msg) {
    if (Debug) {
        FileAppend("[" ScriptId "] " A_Now ": " msg "`n", "./PockestCareScheduler-log.txt", "UTF-8")
    }
}

ValidateWindow() {
    WinWait(WindowTitle, , 5)
    if (not WinExist(WindowTitle)) {
        return False
    }
    return True
}

ResetWindow() {
    WinActivate(WindowTitle)
    WinRestore(WindowTitle)
    WinMove(0, 0, 1000, 1000, WindowTitle)
}

ReloadWindow() {
    ResetWindow()
    Send "{F5}"
}

GetCanvasOffset(val) {
    return val * Size / DefaultSize
}

ClickCareButton(index) {
    ResetWindow()
    yOffset := GetCanvasOffset(30)
    xButtonOffset := GetCanvasOffset(80)
    MouseClick "left", CanvasX + (Size / 2) + ((index - 1) * xButtonOffset), CanvasY + yOffset
}

ClickBottomButton(index) {
    ResetWindow()
    yOffset := GetCanvasOffset(30)
    MouseClick "left", CanvasX + ((Size / 4) + 0.5) * index, CanvasY + Size - yOffset
}

SelectTrainingType(TrainStat) {
    ResetWindow()
    TrainStatDict := Map()
    TrainStatDict["P"] := 0
    TrainStatDict["S"] := 1
    TrainStatDict["T"] := 2
    TrainStatIndex := TrainStatDict[TrainStat]
    MouseClick "left", CanvasX + (Size / 3) * (TrainStatIndex + 0.5), CanvasY + (Size / 2)
}

ClickContinue() {
    ResetWindow()
    yOffset := GetCanvasOffset(70)
    MouseClick "left", CanvasX + (Size / 2), CanvasY + Size - yOffset
}

ClickClose() {
    ResetWindow()
    offset := GetCanvasOffset(2)
    MouseClick "left", CanvasX + Size - offset, CanvasY + Size - offset
}

MenuStatusReset() {
    ResetWindow()
    ClickBottomButton(2)
    Sleep 100
    ClickClose()
}

GetCurFeedLvl() {
    ResetWindow()
    ClickBottomButton(2)
    Sleep 100
    ResetWindow()
    xOffset := CanvasX + GetCanvasOffset(143)
    yOffset := CanvasY + GetCanvasOffset(86)
    heartOffset := GetCanvasOffset(25)
    hearts := 0
    Loop MaxFeed {
        color := PixelGetColor(xOffset + (heartOffset * (A_Index - 1)), yOffset)
        WriteLog("🍎🎨 [GetCurFeedLvl] " A_Index ": " color)
        if (not color = 0x8D8D8D) {
            hearts += 1
        }
    }
    ClickClose()
    return hearts
}

GetAgeName(hourDiff) {
    if (hourDiff < 1) {
        return "Age1"
    }
    if (hourDiff < 12) {
        return "Age2"
    }
    if (hourDiff < 36) {
        return "Age3"
    }
    if (hourDiff < 72) {
        return "Age4"
    }
    if (hourDiff < 168) {
        return "Age5"
    }
    return "Age6"
}

GetTrainingProgress() {
    ResetWindow()
    xOffset := CanvasX + GetCanvasOffset(121)
    yOffset := CanvasY + GetCanvasOffset(257)
    buttonIconHeight := 33
    numSteps := buttonIconHeight
    stepOffset := buttonIconHeight / numSteps
    curStep := 0
    Loop numSteps {
        color := PixelGetColor(xOffset, yOffset + buttonIconHeight - (stepOffset * (A_Index - 1)))
        WriteLog("👟🎨 [GetTrainingProgress] " A_Index ": " color)
        if (color = 0xC69A57 or color = 0xF8D95E or color = 0xCFBE6D or color = 0xB1B59F or color = 0xC0B987) {
            curStep := A_Index
        }
    }
    return curStep / numSteps
}

RandomId(length) {
    id := ""
    str := "0123456789abcdefghijklmnopqrstuvwxyz"
    splitStr := StrSplit(str)
    Loop length {
        rndIndex := Random(1, splitStr.Length)
        id .= splitStr[rndIndex] 
    }
    return id
}

CareLoop() {
    Static lastHourDiff := -1
    Static trainingProgress := 0

    loopId := RandomId(10)
    hourDiff := DateDiff(A_Now, DateOfBirth, "hours")
    hasRunThisHour := hourDiff = lastHourDiff
    lastHourDiff := hourDiff
    ageName := GetAgeName(hourDiff)
    logLoopMsgPrefix := "♻️ [" loopId "]"

    FeedFrequency := IniRead(ConfigFile, "PLAN_" RoutePlan[ageName], "FeedFrequency", 0)
    FeedTarget := IniRead(ConfigFile, "PLAN_" RoutePlan[ageName], "FeedTarget", 0)
    CureFrequency := IniRead(ConfigFile, "PLAN_" RoutePlan[ageName], "CureFrequency", 0)
    CleanFrequency := IniRead(ConfigFile, "PLAN_" RoutePlan[ageName], "CleanFrequency", 0)

    attempToTrain := not Stat = "" and trainingProgress > (11/12)

    WriteLog(logLoopMsgPrefix " 🔝 Start " hourDiff " " ageName " (FeedFrequency: " FeedFrequency ", CureFrequency: " CureFrequency ", CleanFrequency: " CleanFrequency ")")

    ; Exit if Pockest left cause nothing to do
    if (ageName = "Age6") {
        WriteLog(logLoopMsgPrefix " 🔚 Exit <Age6>")
        Exit()
    }

    ; Exit if we've already run the script this hour
    WriteLog(logLoopMsgPrefix " 🕑 Task Check (hasRunThisHour: " hasRunThisHour ", attempToTrain: " attempToTrain ")")
    if (hasRunThisHour and not attempToTrain) {
        WriteLog(logLoopMsgPrefix " 🔚 Exit <NothingToDo>")
        Exit()
    }

    ; Exit if we can't find the window and alert the user
    if (not ValidateWindow()) {
        MsgBox("Cannot find Window. Please open pockest in a separate browser window and ensure the browser window title matches the WindowTitle variable. You can set this within the config ini file.")
        WriteLog(logLoopMsgPrefix " 🔚 Exit <NoWindow>")
        Exit()
    }

    ; Reload in case desync
    ReloadWindow()
    Sleep 5000

    ; In case of evolution
    ClickContinue()
    Sleep 100

    ; Feed?
    if (FeedFrequency > 0 and Mod(hourDiff, FeedFrequency) = 0 and not hasRunThisHour) {
        curFeed := GetCurFeedLvl()
        feedQty := Max(FeedTarget - curFeed, 0)
        WriteLog(logLoopMsgPrefix " 🍎 Feeding " curFeed " -> " FeedTarget " (" feedQty ")")
        Loop feedQty {
            ClickCareButton(0)
            MenuStatusReset()
            Sleep 100
        }
    }

    ; Cure?
    if (CureFrequency > 0 and Mod(hourDiff, CureFrequency) = 0 and not hasRunThisHour) {
        WriteLog(logLoopMsgPrefix " 🩹 Curing")
        ClickCareButton(1)
        MenuStatusReset()
        Sleep 100
    }

    ; Clean?
    if (CleanFrequency > 0 and Mod(hourDiff, CleanFrequency) = 0 and not hasRunThisHour) {
        WriteLog(logLoopMsgPrefix " 🛁 Cleaning")
        ClickCareButton(2)
        MenuStatusReset()
        Sleep 100
    }

    ; Train?
    if (not Stat = "") {
        trainingProgress := GetTrainingProgress()
        WriteLog(logLoopMsgPrefix " 👟 Training Check (trainingProgress: " (Round(trainingProgress, 3) * 100) "%)")
        if (trainingProgress = 1) {
            WriteLog(logLoopMsgPrefix " 👟 Training")
            ClickBottomButton(1)
            Sleep 100
            SelectTrainingType(Stat)
            Sleep 100
            ClickContinue()
            Sleep 15000
            ClickClose()
            lastTrainDiff := hourDiff
        }
    }

    WriteLog(logLoopMsgPrefix " 🔚 Exit <Complete>")
}

+F12:: {
    Static on := False
    If (on := !on) {
        WriteLog("📅 Start Scheduler")
        SetTimer(CareLoop, CareDelay), SoundBeep(1500), CareLoop()
    } Else {
        WriteLog("📅 Stop Scheduler")
        SetTimer(CareLoop, 0), SoundBeep(1000)
    }
}

WriteLog("=====================================================================================================")
WriteLog("📋 " DateOfBirth " | " Divergence1 Divergence2 Stat )
