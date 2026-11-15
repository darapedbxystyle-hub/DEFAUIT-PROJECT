# Security Policy

## Supported version

| Version | Supported |
|---|---|
| 2.1 | Yes |

## Reporting a vulnerability

Please report security issues privately through GitHub Security Advisories
("Security" tab -> "Report a vulnerability") or by opening an issue that does
not include sensitive details.

Do not publish license keys, KeyAuth credentials, or proof-of-concept code in
public issues.

## Scope and warnings

- DEFAUIT requires Administrator rights and changes HKLM registry values,
  network adapter settings, `system.ini`, and FiveM configuration files.
  Only run it on a machine you own or are authorized to manage.
- The application is not code-signed. Verify the SHA256 checksum published in
  `checksums.txt` before running a downloaded copy.
- The licensing system (KeyAuth) requires internet access. KeyAuth app
  credentials are embedded in the distributed binary as required for client
  authentication; this does not grant access to the KeyAuth dashboard.
- The bundled SG TCP Optimizer is third-party software by Speed Guide Inc.
- `install.ps1` downloads official Microsoft installers for .NET Framework 4.8
  and the Visual C++ runtime when they are missing. Review the script before
  running it if you do not trust the source.
