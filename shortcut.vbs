' Usage: cscript shortcut.vbs <filename.lnk> <executable> <arguments>

set objWSHShell = CreateObject("WScript.Shell")
set objFso = CreateObject("Scripting.FileSystemObject")
sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
sArguments = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(2))
sWorkingDirectory = objFso.GetAbsolutePathName(".")
set objSC = objWSHShell.CreateShortcut(sShortcut) 
objSC.TargetPath = sTargetPath
objSC.Arguments = sArguments
objSC.WorkingDirectory = sWorkingDirectory
objSC.Save
