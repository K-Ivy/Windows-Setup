#Requires AutoHotkey v2.0
#SingleInstance Force

; Prompts the user to run the script as Admin.
if not A_IsAdmin {
    Run("*RunAs `"" A_ScriptFullPath "`"")
    ExitApp()
}

; Set Tray Icon.
I_Icon := "S:\2 All Other Files\Scripts\Main\Resource\cd.ico"
If FileExist(I_Icon)
   TraySetIcon I_Icon

; Remove all default tray icons and add defined ones.
A_TrayMenu.Delete
A_TrayMenu.Add('Exit', (*) => ExitApp())

; ---------------------------------------------------------------------
; Easy Window Dragging. Allows dragging from any point inside a window.
; Hold down Windows Key, then drag with left click.
#LButton:: {
    global
    CoordMode("Mouse") ; Switch to screen/absolute coordinates.
    MouseGetPos(&EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin)
    WinGetPos(&EWD_OriginalPosX, &EWD_OriginalPosY, , , "ahk_id " EWD_MouseWin)
    EWD_WinState := WinGetMinMax("ahk_id " EWD_MouseWin)
    ; Only if the window isn't maximized
    if (EWD_WinState = 0)
        SetTimer(EWD_WatchMouse, 10) ; Track the mouse as the user drags it.
    return
}

EWD_WatchMouse() {
    global
    EWD_LButtonState := GetKeyState("LButton", "P") ? "D" : "U"
    ; Button has been released, so drag is complete.
    if (EWD_LButtonState = "U") {
        SetTimer(EWD_WatchMouse, 0)
        return
    }

    EWD_EscapeState := GetKeyState("Escape", "P") ? "D" : "U"
    ; Escape has been pressed, so drag is cancelled.
    if (EWD_EscapeState = "D") {
        SetTimer(EWD_WatchMouse, 0)
        WinMove(EWD_OriginalPosX, EWD_OriginalPosY, , , "ahk_id " EWD_MouseWin)
        return
    }

    ; Otherwise, reposition the window to match the mouse movement
    CoordMode("Mouse")
    MouseGetPos(&EWD_MouseX, &EWD_MouseY)
    WinGetPos(&EWD_WinX, &EWD_WinY, , , "ahk_id " EWD_MouseWin)
    SetWinDelay(-1) ; Makes the move faster/smoother.
    WinMove(
        EWD_WinX + EWD_MouseX - EWD_MouseStartX,
        EWD_WinY + EWD_MouseY - EWD_MouseStartY,
        , , "ahk_id " EWD_MouseWin
    )

    ; Update for the next timer-call to this subroutine.
    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
    return
}

; ------------------------------------------------------------------------------------
; Open Magnifier when "ScrollLock" is pressed. Zoom with "Shift + Mouse Wheel Up/Down"
; Set Magnifer to LENS Mode in setting and adjust the Lens Size.
$ScrollLock:: { ; $ forces keyboard hook
    global
    Send("{LWin down}{NumpadAdd}{LWin up}")
    return
}

~Shift & WheelUp:: {
    global
    Send("{LWin down}{+}{LWin up}")
    return
}

~Shift & WheelDown:: {
    global
    Send("{LWin down}{-}{LWin up}")
    return
}

;---------------------------------
; "Disable normal key functions"
; '$' prefix forces keyboard hook
End::
PgDn::
$NumLock::
$CtrlBreak::
+Insert::   ; Shift + Insert
#Insert::    ; Win + Insert
#W:: ; Disables the Windows Widgets shortcut so not activation happens.
{
} ; disable keys - do nothing