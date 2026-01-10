use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

--based on Erik Johnson's post: 
-- https://apple.stackexchange.com/questions/445872/is-it-possible-to-move-quick-action-from-the-separate-tab-directly-to-context-me/453044#453044

on run
	set libPath to POSIX path of (path to library folder from user domain)
	set strPath to libPath & "Services/"
	set inFile to choose file with prompt "Select a Quick Action file to modify" of type "workflow" default location strPath
	set inPosix to POSIX path of inFile --no slash at end
	try
		do shell script "plutil -remove NSServices.0.NSIconName" & space & quoted form of (inPosix & "/Contents/Info.plist")
		display dialog "Success." & return & return & "The workflow should now appear on the contextual menu, not the Quick Actions menu." buttons {"OK"}
	on error err
		if err contains "no value to remove" then
			display dialog "No change was required. The workflow should appear on the contextual menu, not the Quick Actions menu." buttons {"OK"}
		else
			display dialog err
		end if
	end try
end run
