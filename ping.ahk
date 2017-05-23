
#SingleInstance Force
#NoEnv
Version := 0

TrayTip, %A_ScriptName%, Текущая версия: %Version%

Loop %0%
	ComParam%A_Index% := %A_Index%

If ComParam1 = /Update
	Update(ComParam2, ComParam3)
Else If ComParam1 = /TempDelete
	TempDelete(ComParam2, ComParam3)
Else
	CheckUpdate(Version)
Return

CheckUpdate(Version) {
	Http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), Http.Option(6) := 0
	Http.Open("GET", "https://raw.githubusercontent.com/walempro/1/master/ver.txt")
	Http.Send(), Text := Http.ResponseText
	New := RegExReplace(Text, "i).*?Version\s*(\d+)\s*", "$1")
	If (New <= Version)
		Return
	URLDownloadToFile, https://github.com/walempro/1/blob/master/Update.exe?raw=true, %A_Temp%\Update.exe
	PID := DllCall("GetCurrentProcessId")
	Run %A_Temp%\Update.exe "/Update" "%PID%" "%A_ScriptFullPath%"
	ExitApp
}

Update(PID, Path) {
	Process, Close, %PID%
	Process, WaitClose, %PID%, 3
	If ErrorLevel
	{
		MsgBox, % 16, Update, Не удаётся закрыть процесс
		ExitApp
	}
	FileCopy, %A_ScriptFullPath%, %Path%, 1
	If ErrorLevel
	{
		MsgBox, % 16, Update, Не удалось копирование, возможно были запущены несколько экземпляров программы
		ExitApp
	}
	PID := DllCall("GetCurrentProcessId")
	Run %Path% "/TempDelete" "%PID%" "%A_ScriptFullPath%"
	ExitApp
}

TempDelete(PID, Path) {
	Process, Close, %PID%
	Process, WaitClose, %PID%, 2
	FileDelete, %Path%
}

Escape:: ExitApp