#Requires AutoHotkey v2
#SingleInstance Force
#NoTrayIcon
KillProcesses(["wallpaper32.exe", "steam.exe", "Rainmeter.exe"])
ExitApp
KillProcesses(exes) {
  for exe in exes {
      pid := ProcessExist(exe)
      if (pid) {
          ProcessClose(pid)
      }
  }
}