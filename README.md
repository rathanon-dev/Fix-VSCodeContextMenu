# Fix-VSCodeContextMenu.ps1
> 🚫 **DEPRECATED**: This repository is no longer necessary.  
> Since **Visual Studio Code v1.102.3**, the upstream bug with the context menu has been fixed.  
> 
> ### Rollback / Uninstall
> - Run `uninstall.ps1` (or run `.\Fix-VSCodeContextMenu.ps1` without parameters).  
> - Restart Explorer or sign out/in to refresh the context menus.  
> 
> *(If you really need to test the workaround again, run `.\Fix-VSCodeContextMenu.ps1 -Install -RestartExplorer`.  
> It will create registry keys under `VSCode_Fix`, which can be easily removed and do not conflict with the official keys.)*


[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/rathanon-dev/Fix-VSCodeContextMenu/blob/main/README.md)
[![TH](https://img.shields.io/badge/lang-th-green.svg)](https://github.com/rathanon-dev/Fix-VSCodeContextMenu/blob/main/README.th.md)

A PowerShell script to **check and recreate the "Open with Code" context menu** (as in VSCode version 1.102.3).  
Supports 4 right-click menu locations:
- Files (`*`)
- Folders (`Directory`)
- Empty space in a folder (`Directory\Background`)
- Drives (`Drive`)

Use this if installing a newer VSCode version (e.g., 1.103.0) causes the right-click menu to disappear.

---

## Features
- Works on HKCU (no Admin rights required)
- Automatically detects the location of `Code.exe` from standard install paths
- Warns if VS Code is not found
- Uses `reg.exe` to create and configure Registry keys

---

## Installation & Usage

### 1. Download the script
Right-click the [`Fix-VSCodeContextMenu.ps1`](Fix-VSCodeContextMenu.ps1) file → **Save Link As...**  
Or click **Code → Download ZIP** on GitHub and extract it.

### 2. Open PowerShell
Press **Start** → type `PowerShell` → right-click → **Run as Administrator** *(not required for HKCU, but recommended)*

### 3. Allow script execution temporarily
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### 4. Run the script
For a standard VS Code installation:
```powershell
.\Fix-VSCodeContextMenu.ps1
```

For a custom VS Code installation path:
```powershell
.\Fix-VSCodeContextMenu.ps1 -CodePath "D:\Apps\VSCode\Code.exe"
```

### 5. Restart Explorer
The script will try to restart Explorer automatically.
If it fails, press `Ctrl+Shift+Esc` → find `Windows Explorer` → right-click → Restart.

---

## Verify the result
Run these commands in PowerShell or Command Prompt:

```cmd
reg query "HKCU\Software\Classes\*\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Directory\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Directory\Background\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Drive\shell\VSCode\command" /ve
```

You should see `(Default)` pointing to `"...\Code.exe" "%1"` or `"%V"`

---

## Notes
- On Windows 11, this menu appears under "Show more options" (right-click → classic context menu).
If you want it to show in the modern context menu, you need to manually create a "Modern context menu" entry.
- If you reinstall VS Code with a buggy version, you may need to run this script again after installation.

---
## Demo Videos

https://github.com/user-attachments/assets/3de48ff0-11a4-4990-a76c-501bf85b14ed

---
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
