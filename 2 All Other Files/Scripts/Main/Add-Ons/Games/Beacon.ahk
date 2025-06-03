if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

CoordMode, Mouse, Screen

centerX := 600
centerY := 110

isActive := false
clickHeld := false    ; Tracks if left mouse was pressed (for this drag cycle)
holdJActive := false  ; Tracks if "J" is being held due to a long press

MButton::
    isActive := !isActive
    if (isActive)
    {
        ; On activation, move to the anchor and hold down the left button.
        MouseMove, centerX, centerY, 0
        Sleep, 50
        Send, {LButton down}
        ToolTip, Drag Mode Activated
    }
    else
    {
        Send, {LButton up}  ; Release left button when deactivating
        ToolTip, Drag Mode Deactivated
        Sleep, 1000
        ToolTip
    }
return

~LButton::
if (isActive)
{
    ; If this is the initial press (not a repeated down event)
    if (!clickHeld)
    {
        clickHeld := true
        ; Record the time of press
        downTime := A_TickCount
        ; Start a one-shot timer (300ms) to decide if it becomes a hold
        SetTimer, HoldJTimer, -300
    }
}
return

;---------------------------------------------------------------
; Triggered 300ms after LButton down if still held.
;         If so, begin holding the "J" key.
;---------------------------------------------------------------
HoldJTimer:
if (clickHeld && GetKeyState("LButton", "P"))
{
    holdJActive := true
    Send, {J down}
}
return

;---------------------------------------------------------------
; Send appropriate "J" behavior and reapply left down.
;---------------------------------------------------------------

~LButton Up::
if (isActive)
{
    if (holdJActive)
    {
        ; If in hold mode, release "J"
        holdJActive := false
        Send, {J up}
    }
    else
    {
        ; If the press was a quick tap, send a single "J"
        Send, {J}
    }
    clickHeld := false
    ; Reapply left button down to ensure drag remains active
    Send, {LButton down}
}
return

~RButton::
if (isActive)
{
    Send, {L}
}
return