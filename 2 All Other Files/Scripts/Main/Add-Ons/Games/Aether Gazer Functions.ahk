;if not A_IsAdmin
;{
;    ; Relaunch the script with admin privileges
;    Run *RunAs "%A_ScriptFullPath%"
;    ExitApp
;} 

CoordMode, Mouse, Screen ; Ensure MouseGetPos works relative to the screen
SetTimer, CheckMouseMovement, 10 ; Check mouse movement every 10 milliseconds

; Coordinates the mouse cursor sits
centerX := 50
centerY := 0

prevDirection := ""
isActive := false ; whether the script is active

CheckMouseMovement() {
    global centerX, centerY, prevDirection, isActive
    
    if !isActive
        return ; Skip if the script is inactive
    
    ; Get the current mouse position
    MouseGetPos, currentX, currentY
    diff := currentX - centerX

    ; Handle movement and key states
    if (diff < -1) {
        MoveAndPress("left")
    } else if (diff > 1) {
        MoveAndPress("right")
    } else {
        ReleaseKeys()
    }
    
    ; Process additional keys when active
    CheckAdditionalKeys()

    ; Reset mouse to set position after processing
    DllCall("SetCursorPos", "int", centerX, "int", centerY)
}

MoveAndPress(direction) {
    global prevDirection
    ; Check if the direction has changed
    if (prevDirection != direction) {
        if (direction == "left") {
            Send, {] up} ; Release "L" if held
            Send, {[ down} ; Press "K"
        } else {
            Send, {[ up} ; Release "K" if held
            Send, {] down} ; Press "L"
        }
        prevDirection := direction
    }
}

ReleaseKeys() {
    global prevDirection
    if (prevDirection) { ; Only release if a direction is set
        Send, {[ up}
        Send, {] up}
        prevDirection := "" ; Reset direction
    }
}

CheckAdditionalKeys() {
    ; If left click is pressed, send \ to attack
    if GetKeyState("LButton", "P") {
        Send, {Blind}{\}
		Sleep, 10
    }
	; If spacebar is held down, hold down \ to attack (and for HOLD attack)
    if GetKeyState("Space", "P") {
        Send, {Blind}{\}
        Sleep, 170
    }
}

MButton:: 
    isActive := !isActive ; Toggle activation state
    ToolTip % isActive ? "Aether Functions Activated" : "Aether Functions Deactivated"
    SetTimer, RemoveToolTip, -1000
return

RemoveToolTip() {
    ToolTip
}