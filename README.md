# Fix-VSCodeContextMenu.ps1

สคริปต์ PowerShell สำหรับ **ตรวจสอบและสร้าง Context Menu "Open with Code"** (แบบใน VSCode เวอร์ชัน 1.102.3)  
รองรับเมนูคลิกขวา 4 แบบ:
- ไฟล์ (`*`)
- โฟลเดอร์ (`Directory`)
- พื้นที่ว่างในโฟลเดอร์ (`Directory\Background`)
- ไดรฟ์ (`Drive`)

ใช้ในกรณีที่ติดตั้ง VSCode เวอร์ชันใหม่ (เช่น 1.103.0) แล้วเมนูคลิกขวาหายไป

---

## คุณสมบัติ
- ทำงานกับ HKCU (ไม่ต้องใช้สิทธิ์ Admin)
- ตรวจหาตำแหน่ง `Code.exe` อัตโนมัติใน path มาตรฐาน
- กรณีไม่พบ VS Code จะแจ้งเตือน
- ใช้ `reg.exe` เพื่อสร้างและตั้งค่าคีย์ใน Registry

---

## วิธีติดตั้งและใช้งาน

### 1. ดาวน์โหลดสคริปต์
คลิกขวาที่ไฟล์ [`Fix-VSCodeContextMenu.ps1`](Fix-VSCodeContextMenu.ps1) → **Save Link As...**  
หรือคลิกปุ่ม **Code → Download ZIP** จาก GitHub แล้วแตกไฟล์

### 2. เปิด PowerShell
กดปุ่ม **Start** → พิมพ์ `PowerShell` → คลิกขวา → **Run as Administrator** *(ไม่จำเป็นใน HKCU แต่แนะนำ)*

### 3. อนุญาตการรันสคริปต์ชั่วคราว
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### 4. รันสคริปต์
กรณีติดตั้ง VS Code แบบปกติ:
```powershell
.\Fix-VSCodeContextMenu.ps1
```

กรณีติดตั้ง VS Code ในตำแหน่งอื่น:
```powershell
.\Fix-VSCodeContextMenu.ps1 -CodePath "D:\Apps\VSCode\Code.exe"
```

### 5. รีสตาร์ท Explorer
สคริปต์จะพยายามรีสตาร์ท Explorer ให้อัตโนมัติ  
ถ้าไม่สำเร็จ ให้กด `Ctrl+Shift+Esc` → หา `Windows Explorer` → คลิกขวา → Restart

---

## การตรวจสอบผลลัพธ์
รันคำสั่งเหล่านี้ใน PowerShell หรือ Command Prompt:

```cmd
reg query "HKCU\Software\Classes\*\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Directory\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Directory\Background\shell\VSCode\command" /ve
reg query "HKCU\Software\Classes\Drive\shell\VSCode\command" /ve
```

ควรเห็น `(Default)` ชี้ไปที่ `"...\Code.exe" "%1"` หรือ `"%V"`

---

## หมายเหตุ
- บน Windows 11 เมนูนี้จะอยู่ใน **"Show more options"** (คลิกขวา → เมนูคลาสสิก)  
  หากต้องการให้โผล่ในเมนูแบบใหม่ ต้องใช้วิธีสร้าง "Modern context menu" เพิ่ม
- ถ้าติดตั้ง VS Code ใหม่ เวอร์ชันที่มีบั๊ก อาจต้องรันสคริปต์นี้อีกครั้งหลังติดตั้ง

---
## Demo Videos
https://github.com/user-attachments/assets/1c383f2a-0baa-4ba5-87fe-0ba5c726d182

---
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
