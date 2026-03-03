# WindSlayer Language Patching Tool

A lightweight deployment tool that automatically applies English localization files to the Korean **WindSlayer** client.

This tool is designed for global players who want a safer, faster, and more convenient way to patch language files without manually navigating the client directory.

## Overview

The WindSlayer Language Patching Tool:

- Automatically detects the WindSlayer installation path using the `windslayer://` protocol
- Locates the internal `hs` directory
- Safely backs up existing files before replacing them
- Applies updated localization files in one click
- Provides a restore option to revert to a previous backup

### What This Tool Does

When executed, the tool will:

1. Detect the registered WindSlayer client path from Windows registry.
2. Identify the `hs` folder inside the installation directory.
3. Create a local `backup` folder.
4. Create a timestamp-based backup directory.
5. Backup any existing target files using a timestamped filename.
6. Copy new localization files into the client directory.

### How to Use

#### 1. Download

Download the latest release package in [here](https://github.com/wizley9999/windslayer.io/releases).

```
https://github.com/wizley9999/windslayer.io/releases
```

#### 2. Extract

Extract all files into the same folder.

The folder should contain:

```
## PATCHERS

- run.bat
- hs.ps1
- restore.bat
- hs-restore.ps1

## RESOURCES

- UILngKo.lng
- QSTLngKo.lng
- NPCLngKo.lng
- MapLngKo.lng
- ITMLngKo.lng
- windslayer.hpt
- windslayer.bct
```

#### 3. Execute

Double-click:

```
run.bat
```

Windows will prompt for Administrator permission.

Approve the request.

The patching process will begin automatically.

## Backup System

If a file already exists in the `hs` directory:

- It will be copied into a local `backup` folder.
- A new folder will be created using the following format:

```
backup/YYYYMMDDHHMMSS/
```

Example:

```
backup/20260302114533/
```

All replaced files from that session will be stored inside that folder.

If the file does not exist in the client directory:

- It will simply be copied without backup.

## Restore System

The tool includes a restore script.

When executed:

1. It scans the backup directory.
2. Displays available backup folders sorted by date (newest first).
3. Allows you to select a backup using an index number.
4. Restores all files from the selected backup folder to the hs directory.

Example selection screen:

```
Available backups:
-------------------
[0] 2026-03-02 11:45:33 (20260302114533)
[1] 2026-03-01 10:10:10 (20260301101010)
```

## Limitations

- This tool only replaces specified localization files.
- It does not modify core executables.
- It does not bypass regional restrictions.
- It does not fully translate every part of the client. Some in-game text, system messages, or UI elements may remain in Korean depending on how the original client handles localization.

## Disclaimer

This tool is unofficial and not affiliated with Sesisoft.

Use at your own risk.

The author is not responsible for:

- Account suspensions
- Game restrictions
- Data loss
- System instability
- Any consequences resulting from file modification

Users are responsible for ensuring compliance with the game's Terms of Service.

## Screenshots

![1](2026-03-01-language-patcher/1.png)
