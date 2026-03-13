# 🌤 Weather API Flutter App

## 📱 ภาพรวมของโปรเจค

โปรเจคนี้เป็นแอปพลิเคชัน **Mobile Application ที่พัฒนาด้วย Flutter**
เพื่อดึงข้อมูลสภาพอากาศจาก **Web API (Open-Meteo)** แล้วนำมาแสดงผลบนหน้าจอ

แอปนี้แสดงตัวอย่างการทำงานของ

* การเรียกใช้ **Web API**
* การแปลงข้อมูล **JSON**
* การอัปเดตหน้าจอด้วย **setState**
* การใช้งาน **Flutter Widgets**
* การสร้าง **Navigation ระหว่างหน้า**

---

# 🌐 Web API ที่ใช้

โปรเจคนี้ใช้ API จาก

**Open-Meteo**

https://open-meteo.com/

ตัวอย่าง URL ที่ใช้เรียก API

```
https://api.open-meteo.com/v1/forecast?latitude=18.79&longitude=98.98&current_weather=true
```

API จะส่งข้อมูลกลับมาในรูปแบบ **JSON**

ตัวอย่างข้อมูลที่ได้

```json
{
 "current_weather": {
   "temperature": 30.2,
   "windspeed": 5.4
 }
}
```

---

# ⚙️ ความสามารถของแอป

แอปนี้มีฟังก์ชันหลักดังนี้

### 🌡 แสดงอุณหภูมิและความเร็วลม

แสดงข้อมูลสภาพอากาศปัจจุบัน

* อุณหภูมิ
* ความเร็วลม

---

### 🏙 เลือกเมืองได้

ผู้ใช้สามารถเลือกเมืองผ่าน **Dropdown**

เมืองที่มีในระบบ

* Chiang Mai
* Bangkok
* Phuket
* Khon Kaen

เมื่อเปลี่ยนเมือง แอปจะเรียก API ใหม่

---

### 🎨 พื้นหลังแบบ Gradient

พื้นหลังของแอปจะเปลี่ยนสีตามอุณหภูมิ

ตัวอย่าง

* อุณหภูมิสูง → สีส้ม / สีแดง
* อุณหภูมิปกติ → สีฟ้า
* อุณหภูมิต่ำ → สีเทา / น้ำเงิน

---

### 🔄 Pull to Refresh

ผู้ใช้สามารถ **ลากหน้าจอลงเพื่อโหลดข้อมูลใหม่**

ใช้ Widget

```
RefreshIndicator
```

---

### 🔁 Animated Weather Icon

ไอคอนสภาพอากาศมี **Animation หมุน**

ใช้

```
AnimationController
RotationTransition
```

---

### 📊 หน้าแสดงข้อมูลรายชั่วโมง

มีหน้าที่สองสำหรับแสดงข้อมูล

* อุณหภูมิรายชั่วโมง
* ความชื้น
* ความเร็วลม

ใช้

```
ListView.builder
```

---

### 🔀 Navigation ระหว่างหน้า

ใช้ Flutter Navigator เพื่อเปลี่ยนหน้า

ตัวอย่าง

```
Navigator.push()
```

---

# 🧠 ขั้นตอนการทำงานของแอป

## 1️⃣ เรียก Web API

แอปส่ง HTTP Request ไปยัง Open-Meteo API

```dart
final response = await http.get(url);
```

---

## 2️⃣ แปลงข้อมูล JSON

ข้อมูลที่ได้จาก API จะถูกแปลงเป็น Dart Map

```dart
final data = json.decode(response.body);
```

---

## 3️⃣ ดึงข้อมูลจาก JSON

แอปดึงค่าอุณหภูมิและความเร็วลมจาก JSON

```dart
temperature = data['current_weather']['temperature'];
windspeed = data['current_weather']['windspeed'];
```

---

## 4️⃣ อัปเดตหน้าจอ

ใช้ setState เพื่อให้ Flutter rebuild UI

```dart
setState(() {
 temperature = ...
});
```

---

# 🧩 Widgets ที่ใช้ในโปรเจค

| Widget              | หน้าที่              |
| ------------------- | -------------------- |
| MaterialApp         | โครงสร้างแอป         |
| Scaffold            | โครงสร้างหน้าจอ      |
| DropdownButton      | เลือกเมือง           |
| RefreshIndicator    | Pull to refresh      |
| Card                | แสดงข้อมูลสภาพอากาศ  |
| ListView            | แสดงข้อมูลหลายรายการ |
| Navigator           | เปลี่ยนหน้า          |
| AnimationController | สร้าง Animation      |
<img width="477" height="978" alt="image" src="https://github.com/user-attachments/assets/403f958f-62c1-4395-b716-eb12683f6cd9" />

---

# 📷 ภาพหน้าจอแอป

## หน้าแสดงสภาพอากาศ

<img width="477" height="978" alt="image" src="https://github.com/user-attachments/assets/40479f13-54dd-478d-a2f4-013b7ea9bc63" />


* Dropdown เมือง
* อุณหภูมิ
* ความเร็วลม
* Animated Icon

---

## หน้าแสดงข้อมูลรายชั่วโมง
<img width="477" height="978" alt="image" src="https://github.com/user-attachments/assets/b21370a7-d9b2-4222-9629-c61bd17f823a" />


แสดง

* อุณหภูมิรายชั่วโมง
* ความชื้น
* ความเร็วลม

---

# 🧱 Widget Tree (โครงสร้าง UI)

```
MaterialApp
 └── WeatherPage
      └── Scaffold
           ├── AppBar
           └── Body
                └── RefreshIndicator
                     └── ListView
                          ├── DropdownButton
                          └── Card
                               ├── Animated Icon
                               ├── Temperature Text
                               └── Wind Speed Text
```

---

# 🛠 เทคโนโลยีที่ใช้

* Flutter
* Dart
* REST API
* JSON
* Open-Meteo API

---

# 👨‍💻 ผู้พัฒนา

Kittaphon Laemthai

สาขา Software Engineering

---

# 📚 รายวิชา

Mobile Application Development
