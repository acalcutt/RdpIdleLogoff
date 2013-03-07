Rdp Idle Logoff
https://www.techidiots.net/autoit-scripts/rdp-idle-logoff/
Comments or software bugs may be reported on the techidiots forum at http://forum.techidiots.net
---------------------------------------------------------------------------

=====================================================
Install Instructions
=====================================================
1.) Add RdpIdleLogoff to startup
x86 - Add RdpIdleLogoff_x86.exe to user startup programs (either through run registry or program files startup folder shortcut)
x64 - Add RdpIdleLogoff_x64.exe to user startup programs (either through run registry or program files startup folder shortcut)

2.) Set registry settings (this can be done using group policy preferences)

=====================================================
CONFIGURABLE REGISTRY SETTINGS
=====================================================

NOTE: With the exception of "OverrideHKCU" all settings can be applied to either HKCU or HKLM.
HKLM Path: HKEY_LOCAL_MACHINE\SOFTWARE\RdpIdleLogoff
HKCU Path: HKEY_CURRENT_USER\SOFTWARE\RdpIdleLogoff

--------------------------------
OverrideHKCU (REG_DWORD)
--------------------------------
Description: Causes MACHINE settings (HKLM) to take precedence over USER settings (HKCU). 
Format: integer (0=disabled; 1=enabled; default=0)
NOTE: Applies to MACHINE registry (HKLM) only.

--------------------------------
Enable (REG_DWORD)
--------------------------------
Description: Enables script to run. If not enabled, script exists automatically.
Format: integer (0=disabled; 1=enabled; default=1)

--------------------------------
DisableForAdmins (REG_DWORD)
--------------------------------
Description: Disables script when run as an admin user. If enabled, script exists automatically when run as an admin user.
Format: integer (0=disabled; 1=enabled; default=1)

--------------------------------
ShowAfterInMinutes (REG_DWORD)
--------------------------------
Description: How long the user needs to be idle before the get the log off message in minutes.
Format: integer between 0 and 2,147,483,647 (default=1)

------------------------------
ShowMessageInMinutes(REG_DWORD)
------------------------------
Description: How long to show the log off message before actually logging off in minutes.
Format: integer between 0 and 2,147,483,647 (default=5)

----------------------
CustomMessage (REG_SZ)
----------------------
Description: Allows you to display a custom message rather than one of the default messages.
Format: string (e.g., "Your computer is about to log off!")
Optional Variables:
%username% - Username of the user being logged off
%waittime% - ShowAfterInMinutes value. How long settings say to wait.
%time_remaining% - Displays the time remaining in seconds (e.g., "Your computer will shutdown in %time_remaining% seconds.")
%time_remaining_h% - Displays the hours component of the time remaining in H:M:S format.
%time_remaining_m% - Displays the minutes component of the time remaining in H:M:S format.
%time_remaining_s% - Displays the seconds component of the time remaining in H:M:S format.

