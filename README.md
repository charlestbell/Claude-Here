# Claude Here: "Open in Claude" right-click menu for Windows

Right-click any folder in Windows File Explorer and choose **Open in Claude**. The Claude desktop app opens a new **Claude Code** session with that folder already selected.

No more browsing for your project folder inside the app. Just right-click and go.

- Works on **Windows 10 and Windows 11**
- Works on folders, drives, and the empty space inside an open folder
- No admin rights needed, and it changes nothing outside your own user account
- Uninstalls cleanly in one step

> This is a small community tool. It is not made by or affiliated with Anthropic.

---

## Before you start

You need the **Claude desktop app** for Windows. Get it from [claude.ai/download](https://claude.ai/download) if you don't have it yet.

---

## Install (about 30 seconds)

### Option 1: Copy and paste one line (easiest)

1. Press the **Windows key**, type **PowerShell**, and press **Enter**. A blue or black window opens.
2. Copy this line, paste it into that window (right-click pastes), and press **Enter**:

   ```powershell
   irm https://raw.githubusercontent.com/charlestbell/Claude-Here/main/install.ps1 | iex
   ```

3. When it says **Done!**, close the window. That's it.

### Option 2: Download and double-click

1. Click the green **Code** button at the top of this page, then **Download ZIP**.
2. Open the downloaded ZIP and choose **Extract all**.
3. In the extracted folder, double-click **Install.cmd**.
4. If Windows shows "Windows protected your PC", click **More info**, then **Run anyway**. Windows shows this for any script downloaded from the internet. You can read exactly what it does in [install.ps1](install.ps1).

---

## How to use it

1. In File Explorer, right-click a folder, or right-click empty space inside an open folder.
2. Choose **Open in Claude**.
3. Claude opens a new Code session and asks you to confirm the folder. Confirm it and start working.

**On Windows 11**, Windows tucks extra menu items one level down. Click **Show more options** at the bottom of the right-click menu, or hold **Shift** while you right-click to jump straight to the full menu.

---

## Uninstall

Either paste this into PowerShell:

```powershell
irm https://raw.githubusercontent.com/charlestbell/Claude-Here/main/uninstall.ps1 | iex
```

Or double-click **Uninstall.cmd** from the downloaded folder.

---

## Troubleshooting

**I don't see "Open in Claude".**
On Windows 11, look under **Show more options** or hold **Shift** while right-clicking. If it still isn't there, run the installer again from a normal PowerShell window (see the note below).

**I asked Claude to install this for me and it doesn't show up.**
The Claude desktop app from the Microsoft Store runs in a sandbox. Anything it writes to your settings stays inside that sandbox, where File Explorer can't see it. Run the installer yourself from PowerShell or with Install.cmd instead.

**It says the Claude desktop app isn't installed.**
Install it from [claude.ai/download](https://claude.ai/download), open it once, then run the installer again.

**The menu item opens Claude but not my folder.**
Update the Claude desktop app. Opening a folder from a link needs a recent version.

**A window flashes for a moment when I click it.**
That's normal. A tiny hidden PowerShell script passes the folder to Claude, and Windows sometimes shows its window briefly.

**The menu item has no Claude icon.**
Run the installer again. It copies the icon from your installed Claude app, so Claude needs to be installed when you run it.

---

## How it works

The installer does three small things:

1. Saves a short launcher script to `%LOCALAPPDATA%\ClaudeHere\open-in-claude.ps1`, plus a copy of the Claude app's icon (`claude.ico`) taken from your own installed app. The copy keeps the menu icon working after Claude updates.
2. Adds an **Open in Claude** entry, with the Claude icon, to your right-click menu, under `HKEY_CURRENT_USER\Software\Classes` for folders, folder backgrounds and drives. It touches only your own user account, so no admin rights are needed.
3. When you click the entry, the launcher opens this link with your folder filled in:

   ```
   claude://code/new?folder=<your folder>
   ```

   The Claude desktop app handles that link and opens a new Claude Code session for the folder. This link format is documented in Anthropic's help article [Open Claude Desktop with a link](https://support.claude.com/en/articles/14729294-open-claude-desktop-with-a-link).

The uninstaller removes those menu entries and the launcher folder.

---

## Files

| File | What it is |
| --- | --- |
| `install.ps1` | Installs the right-click entry |
| `uninstall.ps1` | Removes it |
| `Install.cmd` / `Uninstall.cmd` | Double-click versions of the two scripts |

---

## License

[MIT](LICENSE). Free to use, change and share.

<!-- Keywords: Claude, Claude Code, Claude desktop, Anthropic, Windows, File Explorer, right-click, context menu, "Open with Claude", "Open in Claude", "Claude here", open folder in Claude Code, Windows 11 context menu, shell extension -->
