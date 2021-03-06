;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpdateParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "maint"


;TODO make a gui instead
;Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
;Gui, Color, 000032
Gui, Add, Button, , Send File To Mitsi
Gui, Add, Button, , Cleanup Server Supervision
Gui, Add, Button, , Time Since Last Reboot
Gui, Add, Button, , Turn Off Output Alarms
;get status of all lynx related services
Gui, Add, Button, , Debug Test
Gui, Show, , Lynx Maintenance Panel

;the end of the maintenance
;TODO put this in a separate file and just run it with no tray icon
SleepMinutes(60*12)
Shutdown, 4
ExitApp

ButtonSendFileToMitsi:
SendFileHome()
return
ButtonCleanupServerSupervision:
CleanupServerSupervision()
msg("Finished Server Supervision Cleanup")
return
ButtonTimeSinceLastReboot:
TimeSinceLastReboot()
return
ButtonTurnOffOutputAlarms:
TurnOffOutputAlarms()
return
ButtonDebugTest:
DebugTest()
return

;ghetto hotkey
;Appskey & r::
;SetTitleMatchMode, 2
;WinActivate, Notepad
;WinWaitActive, Notepad
;Sleep, 200
;Send, {ALT}fs
;Sleep, 200
;reload
;return



SendFileHome()
{
   delog("", "started function", A_ThisFunc)

   reasonForScript := GetLynxMaintenanceType()
   joe := GetLynxPassword("ftp")
   timestamp := CurrentTime("hyphenated")
   date := CurrentTime("hyphendate")

   filePath := Prompt("What file do you want to send?`n`nProvide the full path")
   if NOT FileExist(filePath)
   {
      msg("File specified does not exist. Please provide the full path.")
      return
   }
   RegExMatch(filePath, ".{3}$", fileExtension)

   description := Prompt("Provide a description...")
   description := RegExReplace(description, "[^A-Za-z0-9]", "-")

   ;try to send it back using MS-ftp
   joe := GetLynxPassword("ftp")
   ftpFilename=ftp.txt

ftpfile=
(
open lynx.mitsi.com
AHK
%joe%
put "%filepath%" "other/%description%.%fileExtension%"
quit
)

   FileCreate(ftpfile, ftpFilename)
   ret:=CmdRet_RunReturn("ftp -s:" . ftpFilename)
   ;debug(ret)
   delog(ret)
   FileDelete(ftpFilename)

   ;TODO ensure that the file got to the ftp site (use a GET)

   msg("Finished File Transmission... please check the FTP site to ensure it is there")

   delog("", "finished function", A_ThisFunc)
}

TimeSinceLastReboot()
{
   tick := A_TickCount . " (in ms)"
   convert := A_TickCount . " (convert)"
   pretty := PrettyTickCount(A_TickCount) . " (pretty)"
   debug("Time Since Last Reboot", tick, convert, pretty)
}

TurnOffOutputAlarms()
{
   CmdRet_RunReturn("sc stop LynxMessageServer")
   CmdRet_RunReturn("sc stop LynxMessageServer2")
   CmdRet_RunReturn("sc stop LynxMessageServer3")
   CmdRet_RunReturn("sc stop LynxTCPservice")
   CmdRet_RunReturn("sc stop LynxClientManager")
   Sleep, 5000
   PermanentDisableService("LynxMessageServer")
   PermanentDisableService("LynxMessageServer2")
   PermanentDisableService("LynxMessageServer3")
   PermanentDisableService("LynxTCPservice")
   PermanentDisableService("LynxClientManager")
}

DebugTest()
{
;AttachDatabase("C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data\lLynx.mdf")
;AttachDatabase("C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\lLynx.mdf")
}

;tempFile := "C:\temp\out.txt"

;TestCmdRet()
;;debug("tested cmd ret")
;;return

   ;;Run, set > C:\temp\out.txt
   ;;ret := FileRead(tempFile)
   ;;debug(ret)
   ;;return

   ;FileDelete(tempFile)
   ;;FileCreate(tempFile)
   ;FileCreate("", tempFile)
   ;ret := CmdRet_RunReturn("set > out.txt", "C:\temp\")
   ;;ret := CmdRet_RunReturn("set > C:\temp\out.txt", "C:\temp\")
   ;ret := FileRead(tempFile)
   ;FileDelete(tempFile)
   ;debug("sent to file3")
   ;debug(ret)
   ;ret := CmdRet_RunReturn("wmic os get totalvisiblememorysize")
   ;debug(ret)
   ;ret := CmdRet_RunReturn("wmic os get freephysicalmemory")
   ;debug(ret)


   ;;cgiDir := LynxDatabaseQuerySingleItem("select value from setup where [type] = 'bin'", "value")
   ;;lynx_message(cgiDir)

   ;;GetSqlVersion()
   ;;RenameLynxguideAlarmChannels()
   ;;CheckDatabaseFileSize()

   ;;SqlVersion := LynxDatabaseQuery("Select @@version as version", "version")
   ;;CompanyName := GetCompanyName()
   ;;;delog("CompanyName was", CompanyName)
   ;;msg("SQL version was " . SQLversion)
   ;;msg("CompanyName was " . CompanyName)
