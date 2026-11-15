# DEFAUIT PROJECT v2.1

เครื่องมือปรับแต่ง Windows สำหรับเกมเมอร์ (Network / Registry / Adapter Tweaker) พร้อมตัวติดตั้งอัตโนมัติสำหรับ Windows 10/11 64-bit

> แอปต้องรันด้วยสิทธิ์ **Administrator** และต้องมี **License Key (KeyAuth)** ที่ยังใช้งานได้
> ค่า tweak บางรายการแก้ registry ระดับระบบ แนะนำให้สร้าง System Restore Point ก่อนใช้งาน

---

## รันได้เลย ไม่ต้องติดตั้ง (แนะนำ)

เปิด **Windows PowerShell** แล้ววางคำสั่งนี้:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://github.com/darapedbxystyle-hub/DEFAUIT-PROJECT/releases/download/v2.1/DEFAUIT-run.ps1 | iex"
```

- ไม่ติดตั้งลงเครื่อง: ไม่มี shortcut และไม่สร้างโฟลเดอร์ใน LocalAppData
- ดาวน์โหลด `DEFAUIT.exe` ไปที่ `%TEMP%\DEFAUIT-Run` ตรวจ SHA256 แล้วเปิดแอปทันที
- เปิดแอปด้วยสิทธิ์ Administrator (กด Yes ที่หน้าต่าง UAC)
- เครื่องต้องมี .NET Framework 4.8 และ VC++ Runtime อยู่แล้ว (Windows 10/11 ปกติมีให้); ถ้าขาดสคริปต์จะแจ้งลิงก์ดาวน์โหลด
- ไฟล์ชั่วคราวอยู่ใน `%TEMP%\DEFAUIT-Run` ลบทิ้งได้ตลอดเมื่อปิดแอป

## ติดตั้งแบบมี shortcut (ทางเลือก)

ถ้าต้องการ shortcut บน Desktop / Start Menu และติดตั้งไว้ที่ `%LOCALAPPDATA%\DEFAUIT` ให้ใช้คำสั่งนี้แทน:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/install.ps1 | iex"
```

## รันแบบ Portable (ZIP)

1. ดาวน์โหลด `DEFAUIT-PROJECT-v2.1-Portable.zip` จาก [Releases](https://github.com/darapedbxystyle-hub/DEFAUIT-PROJECT/releases/latest)
2. แตกไฟล์ไว้ที่โฟลเดอร์ที่ต้องการ
3. เลือกวิธีใช้:
   - `Run without install.cmd` - รันเลยโดยไม่ติดตั้ง (ใช้ `%TEMP%\DEFAUIT-Run`)
   - `Run DEFAUIT.cmd` - ติดตั้งแบบ portable พร้อม shortcut

หรือดาวน์โหลด `DEFAUIT.exe` ตรงจาก Releases แล้วคลิกขวา > **Run as administrator**

---

## สคริปต์ทำอะไรบ้าง

**`run.ps1` (รันโดยไม่ติดตั้ง)**
1. ตรวจว่าเป็น Windows 64-bit และมี .NET Framework 4.8 / VC++ Runtime
2. ดาวน์โหลด `DEFAUIT.exe` จาก GitHub Releases ไปที่ `%TEMP%\DEFAUIT-Run`
3. ตรวจ SHA256 และปลดล็อกไฟล์
4. เปิดแอปด้วยสิทธิ์ Administrator (UAC)
5. ไม่สร้าง shortcut และไม่ติดตั้งลง LocalAppData

**`install.ps1` (ติดตั้งแบบมี shortcut)**
1. ตรวจว่าเป็น Windows 64-bit
2. ติดตั้ง .NET Framework 4.8 ให้ถ้ายังไม่มี
3. ติดตั้ง Visual C++ 2015-2022 Runtime (x64) ให้ถ้ายังไม่มี
4. ดาวน์โหลด `DEFAUIT.exe`, ตรวจ SHA256 และปลดล็อกไฟล์
5. ติดตั้งไว้ที่ `%LOCALAPPDATA%\DEFAUIT` และสร้าง shortcut บน Desktop / Start Menu
6. เปิดแอปด้วยสิทธิ์ Administrator

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
run.ps1                         รันโดยไม่ติดตั้ง (ดาวน์โหลดไป %TEMP%)
install.ps1                     ติดตั้ง / portable launcher พร้อม shortcut
Run without install.cmd         ตัวเปิดแบบไม่ติดตั้งสำหรับ ZIP
Run DEFAUIT.cmd                 ตัวเปิดแบบติดตั้งสำหรับ ZIP
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
