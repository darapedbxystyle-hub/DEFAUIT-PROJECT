# DEFAUIT PROJECT v2.1

เครื่องมือปรับแต่ง Windows สำหรับเกมเมอร์ (Network / Registry / Adapter Tweaker) พร้อมตัวติดตั้งอัตโนมัติสำหรับ Windows 10/11 64-bit

> แอปต้องรันด้วยสิทธิ์ **Administrator** และต้องมี **License Key (KeyAuth)** ที่ยังใช้งานได้
> ค่า tweak บางรายการแก้ registry ระดับระบบ แนะนำให้สร้าง System Restore Point ก่อนใช้งาน

---

## ติดตั้งด้วยคำสั่งเดียว

เปิด **Windows PowerShell** (ไม่ต้อง Run as administrator) แล้ววางคำสั่งนี้:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/install.ps1 | iex"
```

ตัวติดตั้งจะตรวจ/ติดตั้งสิ่งที่ขาดให้อัตโนมัติ แล้วเปิดแอปพร้อมสิทธิ์ Administrator

## ติดตั้งแบบ Portable (ZIP)

1. ดาวน์โหลด `DEFAUIT-PROJECT-v2.1-Portable.zip` จาก [Releases](https://github.com/darapedbxystyle-hub/DEFAUIT-PROJECT/releases/latest)
2. แตกไฟล์ไว้ที่โฟลเดอร์ที่ต้องการ
3. ดับเบิลคลิก `Run DEFAUIT.cmd`

หรือดาวน์โหลด `DEFAUIT.exe` ตรงจาก Releases แล้วคลิกขวา > **Run as administrator**

---

## ตัวติดตั้งทำอะไรบ้าง

1. ตรวจว่าเป็น Windows 64-bit
2. ติดตั้ง .NET Framework 4.8 ให้ถ้ายังไม่มี
3. ติดตั้ง Visual C++ 2015-2022 Runtime (x64) ให้ถ้ายังไม่มี
4. ดาวน์โหลด `DEFAUIT.exe` จาก GitHub Releases, ตรวจ SHA256 และปลดล็อกไฟล์
5. ติดตั้งไว้ที่ `%LOCALAPPDATA%\DEFAUIT` และสร้าง shortcut บน Desktop / Start Menu
6. เปิดแอปด้วยสิทธิ์ Administrator (จะมีหน้าต่าง UAC ให้กด Yes)

ติดตั้งแบบ per-user ไม่ต้องใช้สิทธิ์ admin ในการติดตั้ง แต่ตอนเปิดแอปต้องกด UAC

## ความต้องการของระบบ

| รายการ | รายละเอียด |
|---|---|
| Windows | Windows 10 หรือ 11 แบบ 64-bit (แนะนำ) |
| สถาปัตยกรรม | x64 เท่านั้น (ไม่รองรับ 32-bit / ARM64) |
| Runtime | .NET Framework 4.8 และ VC++ 2015-2022 x64 (ตัวติดตั้งจัดการให้) |
| สิทธิ์ | Administrator สำหรับการแก้ registry / network |
| Internet | จำเป็นสำหรับตรวจ License Key (KeyAuth) และหน้า Toolkit บางรายการ |

## License Key (KeyAuth)

- เปิดแอปแล้วกรอกคีย์ในหน้า **SECURE GATE** แล้วกด **LOGIN**
- ถ้าคีย์ผูกกับ HWID ของเครื่องเดิม ต้องรีเซ็ต HWID ในระบบ KeyAuth ก่อนใช้เครื่องใหม่
- ถ้าขึ้น `CONNECTION FAILED - CHECK INTERNET` ให้ตรวจอินเทอร์เน็ต / VPN / proxy แล้วลองใหม่

## หน้าในแอป

- **OVERVIEW** - ข้อมูลเครื่อง, CPU load, RAM, uptime, การ์ดจอ, ดิสก์, อะแดปเตอร์เครือข่าย
- **NETWORK** - SETTING DEFAUIT, INTERNET DEFAUIT, MOUSE KEYBORD DEFAUIT, RESET DEFAUIT
- **TOOLKIT** - System Properties, gpedit, Control Panel, Chris Titus WinUtil, TCP Optimizer, FiveM CitizenFX.ini, system.ini, Timer Resolution
- **ADAPTER TWEAKER** - เลือกอะแดปเตอร์ของเครื่องนั้น ๆ แล้วโหลด/ปรับค่า RSS, Interface, Advanced, Power, AFD

> การปรับค่าระดับอะแดปเตอร์ให้ใช้หน้า **ADAPTER TWEAKER** เพราะอ่านอะแดปเตอร์จริงของแต่ละเครื่อง

## คืนค่าระบบ (Reset)

- กด **RUN RESET DEFAUIT** ในหน้า NETWORK แล้วรีสตาร์ทเครื่อง
- ไฟล์ `system.ini` เดิมถูกเก็บเป็น `system.ini.bak`
- ไฟล์ FiveM `CitizenFX.ini` เดิมถูกเก็บเป็น `.bak`
- ปิด Timer Resolution ได้ด้วยปุ่มในหน้า TOOLKIT หรือรัน `uninstall.ps1` (จะลบ task `DEFAUIT_TimerResolution`)

## แก้ปัญหา

**Windows SmartScreen ขึ้น "Windows protected your PC"**
ไฟล์ไม่ได้ code-sign จึงต้องกด **More info > Run anyway** (ตรวจ SHA256 ในไฟล์ `checksums.txt` ก่อนได้)

**UAC ไม่ขึ้น / แอปบอกให้รัน as Administrator**
ปิดแอปแล้วเปิดใหม่ผ่าน shortcut `DEFAUIT` หรือคลิกขวา `DEFAUIT.exe` > Run as administrator

**ติดตั้ง .NET Framework 4.8 ไม่สำเร็จ**
ดาวน์โหลดตัวติดตั้งจาก Microsoft โดยตรง: <https://go.microsoft.com/fwlink/?LinkId=2088631> แล้วรีสตาร์ทเครื่อง

**ติดตั้ง Visual C++ Runtime ไม่สำเร็จ**
ดาวน์โหลดจาก Microsoft: <https://aka.ms/vs/17/release/vc_redist.x64.exe>

**gpedit.msc เปิดไม่ได้**
Windows Home Edition ไม่มี Group Policy Editor เป็นข้อจำกัดของ Windows

**Antivirus / Defender แจ้งเตือน**
แอปแก้ registry และมี TCP Optimizer ฝังอยู่ภายใน อาจถูก flag แบบ false positive ให้ตรวจ SHA256 และเพิ่ม exclusion เฉพาะเมื่อเชื่อถือไฟล์นี้เท่านั้น

**Timer Resolution ยังไม่กลับค่าเดิม**
ปิดจากหน้า TOOLKIT หรือรัน `uninstall.ps1` เพื่อลบ scheduled task `DEFAUIT_TimerResolution`

## ความปลอดภัยและความเป็นส่วนตัว

- แอปเขียนค่าใน `HKLM\SYSTEM` และ `HKCU`, สร้าง scheduled task และแก้ไฟล์ `system.ini` / `CitizenFX.ini`
- ใช้บนเครื่องที่คุณเป็นเจ้าของหรือมีสิทธิ์ดูแลเท่านั้น
- ตัวแอปมีข้อมูลแอป KeyAuth ฝังอยู่ภายในเพื่อใช้ล็อกอิน (จำเป็นสำหรับการตรวจคีย์) ไม่ควรดัดแปลงหรือแจกจ่ายไบนารีนอกช่องทางของเจ้าของ
- ไม่มี warranty: การปรับค่าระบบเป็นความเสี่ยงของผู้ใช้เอง

## Third-party

- **SG TCP Optimizer 4.1.0.0** (Speed Guide Inc.) ถูกฝังอยู่ภายใน `DEFAUIT.exe` - ลิขสิทธิ์เป็นของเจ้าของเดิม
- **Chris Titus WinUtil** เปิดจาก <https://christitus.com/win> (ไม่ได้รวมในไฟล์)
- **KeyAuth** (<https://keyauth.win>) สำหรับระบบลิขสิทธิ์
- วิดีโอพื้นหลัง/โลโก้เป็นส่วนหนึ่งของ DEFAUIT PROJECT

## Checksums

```
7B6EB91E136F9043CBF396B8CA83945674BFBC5C2F0F3DBE0177FEBF6F273828  DEFAUIT.exe
```

ขนาดไฟล์: 4,457,472 bytes

## โครงสร้าง repo

```
DEFAUIT.exe                     ไบนารีหลัก (v2.1)
install.ps1                     ตัวติดตั้ง / portable launcher
Run DEFAUIT.cmd                 ตัวเปิดสำหรับโฟลเดอร์ portable
uninstall.ps1                   ถอนการติดตั้ง + ลบ shortcut/task
checksums.txt                   SHA256
README.md
LICENSE
SECURITY.md
```

## License

โปรแกรมนี้เป็นลิขสิทธิ์ของ DEFAUIT PROJECT (All rights reserved) ดูรายละเอียดใน [LICENSE](LICENSE) - อนุญาตให้ดาวน์โหลดและใช้งานส่วนตัว ห้ามดัดแปลงหรือแจกจ่ายเวอร์ชันดัดแปลงโดยไม่ได้รับอนุญาต

---

## English summary

DEFAUIT PROJECT v2.1 is a portable Windows 10/11 x64 network and gaming tweaker. Install with the one-line PowerShell command above or use the portable ZIP. The installer verifies SHA256, installs .NET Framework 4.8 / VC++ runtime when missing, creates shortcuts, and launches the app elevated. A valid KeyAuth license key and internet access are required. Use at your own risk.
