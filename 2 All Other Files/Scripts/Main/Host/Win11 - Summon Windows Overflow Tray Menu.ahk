#Requires AutoHotkey v2.0
; K-Ivy: https://github.com/K-Ivy/Windows-Stuff/tree/main/2%20All%20Other%20Files/Scripts

; Manually adjust or search and find "AutoHotKey Window Spy" and open it and get the X and Y of where you want to move the tray menu to. Avoid a Y that overlaps the dock! Otherwise, when the tray menu is focused, the dock will hide if set to hide on overlap (Seelen-Ui).
TrayMoveX := 683
TrayMoveY := 220

;  Keybinds Info:
; ------------------
; ^   is Ctrl / Control key
; >^   is RCtrl / right control key
; <^   is LCtrl / left control key
; !   is Alt key
; >!   is RAlt / right ALT
; <!   is LAlt / left ALT
; <^>!   is ALTGr (LControl & RAlt)
; #   is Windows / Win key
; +   is Shift key
; Example: !S = Alt + S
; ------------------

$F1:: {
  ; Use Key to open tray
  Send "#b"
  Sleep 50
  Send "{Enter}"
  ; Wait for the tray window to exist
  if !WinWait(Win11ovfWinClass, , 1) {
  MsgBox "Oops! Too Fast..."
    return
  }
  ; Activate & move the tray window to pos
  hwnd := WinGetID(Win11ovfWinClass)
  MoveWindow(hwnd, TrayMoveX, TrayMoveY)
  WinActivate(hwnd)
}

Esc:: {
  ; With "Try", if the window is not found, Catch returns, stopping AutoHotkey's error window from triggering.
  try hwnd := WinGetID(Win11ovfWinClass)
    catch { 
      return 
    }
  DllCall("ShowWindow", "Ptr", hwnd, "Int", 0)
}

; Tray Class
Win11ovfWinClass := "ahk_class TopLevelWindowForOverflowXamlIsland"

; Move Function
MoveWindow(hwnd, x, y) {
  rect := Buffer(16, 0)
  if !DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", rect.Ptr)
    return false
  windowWidth := NumGet(rect, 8, "Int") - NumGet(rect, 0, "Int")
  windowHeight := NumGet(rect, 12, "Int") - NumGet(rect, 4, "Int")
  return DllCall("MoveWindow", "Ptr", hwnd, "Int", x, "Int", y, "Int", windowWidth, "Int", windowHeight, "Int", true) != 0
}