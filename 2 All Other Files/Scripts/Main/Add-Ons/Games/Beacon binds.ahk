#Requires AutoHotkey v2.0

; Global state variables
global isActive    := false
global clickHeld   := false
global holdJActive := false
global downTime    := 0

MButton::
{
    global isActive
    isActive := !isActive
    if isActive {
        ToolTip "Script Activated"
    } else {
        ToolTip "Script Deactivated"
    }
    Sleep 500
    ToolTip() ; Clear the tooltip
}

~LButton::
{
    global isActive
    if !isActive
        return
    LeftButtonDownHandler()
}

~LButton Up::
{
    global isActive
    if !isActive
        return
    LeftButtonUpHandler()
}

~RButton::
{
    global isActive
    if !isActive
        return
    RButtonHandler()
}

LeftButtonDownHandler() {
    global clickHeld, holdJActive, downTime
    if !clickHeld {
        clickHeld := true
        downTime := A_TickCount
        SetTimer(HoldJTimer, -300)
    }
}

HoldJTimer(*) {
    global clickHeld, holdJActive
    if (clickHeld && GetKeyState("LButton", "P")) {
        holdJActive := true
        Send("{J down}")
    }
}

LeftButtonUpHandler() {
    global clickHeld, holdJActive
    if holdJActive {
        holdJActive := false
        Send("{J up}")
    } else {
        Send("{J}")
    }
    clickHeld := false
}

RButtonHandler() {
    Send("{L}")
}
