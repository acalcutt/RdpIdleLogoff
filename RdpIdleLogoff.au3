#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=warning.ico
#AutoIt3Wrapper_Outfile=RdpIdleLogoff_x86.exe
#AutoIt3Wrapper_Outfile_x64=RdpIdleLogoff_x64.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;License Information-------------------------------------
;Copyright (C) 2013
;This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; Version 2 of the License.
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
;You should have received a copy of the GNU General Public License along with this program; If not, see <http://www.gnu.org/licenses/gpl-2.0.html>.
;Program Information-------------------------------------
;Script_Author = 'Andrew Calcutt'
;Script_Name = 'RdpIdleLogoff.au3'
;Script_Function = 'Prompts to log off after a specified time. If the user does not respond or choose to log off the session will automatically log out'
;Date = '2013/03/05'
;Version = 0.1
;--------------------------------------------------------
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>
Opt("TrayIconHide", 1)

;--Defaults
$enabled = 1
$disableforadmins = 0
$waittime = 1
$showtime = 5
$custommessage = "Windows has detected no user activity in %waittime% minute(s). User '%username%' will be logged off in %time_remaining_m% minutes and %time_remaining_s% seconds"
_GetSettingsFromRegisty()

;--Exit if Disabled
If $enabled = 0 Then Exit
If $disableforadmins = 1 And IsAdmin() Then Exit

;Run Script
While 1 ; Monitor idle time
	$iIdleTime = _Timer_GetIdleTime()
	If $iIdleTime > ($waittime * 60000) Then ;Idle maximum time reached, dispaly message
		$ShowMessageTimer = TimerInit()
		$Information = GUICreate("Logging Off", 450, 150, -1, -1)
		$ActionMessageGUI = GUICtrlCreateLabel(_MessageVariables($custommessage, TimerDiff($ShowMessageTimer)), 15, 25, 420, 100)
		$ActionNowButton = GUICtrlCreateButton("Log Off Now", 175, 120, 130, 25)
		$ActionCancelButton = GUICtrlCreateButton("Cancel", 310, 120, 130, 25)
		GUISetState(@SW_SHOW)
		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE ;Exit back to idle timer
					ExitLoop
				Case $ActionCancelButton ;Exit back to idle timer
					ExitLoop
				Case $ActionNowButton ;Log off user
					Run("shutdown.exe /l /f", @SystemDir)
					Exit
			EndSwitch
			If TimerDiff($ShowMessageTimer) > ($showtime * 60000) Then ;Maximum time to show message reached, log off user
				Run("shutdown.exe /l /f", @SystemDir)
				Exit
			EndIf
			$displaymsg = _MessageVariables($custommessage, TimerDiff($ShowMessageTimer))
			If GUICtrlRead($ActionMessageGUI) <> $displaymsg Then GUICtrlSetData($ActionMessageGUI, $displaymsg)
			Sleep(100)
		WEnd
		GUIDelete($Information)
	EndIf
	Sleep(60000)
WEnd

Func _MessageVariables($message, $timerval)
	$timeleftms = ($showtime * 60000) - $timerval
	$timeleftsec = $timeleftms / 1000
	$sec2time_hour = Int($timeleftsec / 3600)
	$sec2time_min = Int(($timeleftsec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $timeleftsec - $sec2time_hour * 3600 - $sec2time_min * 60

	$message = StringReplace($message, "%username%", @UserName)
	$message = StringReplace($message, "%waittime%", $waittime)
	$message = StringReplace($message, "%time_remaining%", Round($timeleftsec))
	$message = StringReplace($message, "%time_remaining_h%", Round($sec2time_hour))
	$message = StringReplace($message, "%time_remaining_m%", Round($sec2time_min))
	$message = StringReplace($message, "%time_remaining_s%", Round($sec2time_sec))
	Return ($message)
EndFunc   ;==>_MessageVariables

Func _GetSettingsFromRegisty()
	;-- Set if HKLM overwrites HKCU settings (1 if enabled, 0 if disabled)
	$overridehkcu = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "OverrideHKCU")

	;--Enable RdpIdleLogoff to run
	$enabled_hklm = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "Enabled")
	$enabled_hkcu = RegRead("HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff", "Enabled")
	If $enabled_hklm <> "" And $overridehkcu = 1 Then
		$enabled = $enabled_hklm
	ElseIf $enabled_hkcu <> "" Then
		$enabled = $enabled_hkcu
	ElseIf $enabled_hklm <> "" Then
		$enabled = $enabled_hklm
	EndIf

	;---Diable for admin users
	$disableforadmins_hklm = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "DisableForAdmins")
	$disableforadmins_hkcu = RegRead("HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff", "DisableForAdmins")
	If $disableforadmins_hklm <> "" And $overridehkcu = 1 Then
		$disableforadmins = $disableforadmins_hklm
	ElseIf $disableforadmins_hkcu <> "" Then
		$disableforadmins = $disableforadmins_hkcu
	ElseIf $disableforadmins_hklm <> "" Then
		$disableforadmins = $disableforadmins_hklm
	EndIf

	;--Time to wait before showing logoff prompt in minutes
	$waittime_hklm = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "ShowAfterInMinutes")
	$waittime_hkcu = RegRead("HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff", "ShowAfterInMinutes")
	If $waittime_hklm <> "" And $overridehkcu = 1 Then
		$waittime = $waittime_hklm
	ElseIf $waittime_hkcu <> "" Then
		$waittime = $waittime_hkcu
	ElseIf $waittime_hklm <> "" Then
		$waittime = $waittime_hklm
	EndIf

	;--Time show the logoff prompt before forcing a logoff
	$showtime_hklm = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "ShowMessageInMinutes")
	$showtime_hkcu = RegRead("HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff", "ShowMessageInMinutes")
	If $showtime_hklm <> "" And $overridehkcu = 1 Then
		$showtime = $showtime_hklm
	ElseIf $showtime_hkcu <> "" Then
		$showtime = $showtime_hkcu
	ElseIf $showtime_hklm <> "" Then
		$showtime = $showtime_hklm
	EndIf

	;--Message to dispalay at logoff
	$custommessage_hklm = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff", "CustomMessage")
	$custommessage_hkcu = RegRead("HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff", "CustomMessage")
	If $custommessage_hklm <> "" And $overridehkcu = 1 Then
		$custommessage = $custommessage_hklm
	ElseIf $custommessage_hkcu <> "" Then
		$custommessage = $custommessage_hkcu
	ElseIf $custommessage_hklm <> "" Then
		$custommessage = $custommessage_hklm
	EndIf
EndFunc
