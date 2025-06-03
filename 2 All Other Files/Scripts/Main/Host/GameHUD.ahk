#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; Launch Rainmeter (if not running)
rainExe := "C:\Program Files\Rainmeter\Rainmeter.exe"
if (!ProcessExist("Rainmeter.exe")) {
    if !FileExist(rainExe) {
        MsgBox("Error: Cannot find Rainmeter at " . rainExe, , "Launch Failed")
        ExitApp
    }
    Run(rainExe)
  }
Sleep 300

; Activate the desktop window so scrolling works on the hud
WinActivate("ahk_class Progman")

; Toggle Rainmeter skin. Double needed.
Run('"C:\Program Files\Rainmeter\Rainmeter.exe" !ToggleConfig "GameHUB V2\Launch" "GameHUB.ini"')
Run('"C:\Program Files\Rainmeter\Rainmeter.exe" !ToggleConfig "GameHUB V2\Launch" "GameHUB.ini"')

ExitApp