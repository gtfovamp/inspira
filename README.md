# 🎨 Inspira - Flutter iOS Drawing App

---

## ✨ Synopsis
**Inspira** is a modern iOS mobile app built with **Flutter** and **Firebase**.  
It allows users to:  
- Register and login via email  
- Create and edit drawings on a canvas  
- Import images from the device gallery  
- Save and export drawings  
- Manage images in **Firebase**  

The interface strictly follows **Figma designs** for a minimal, user-focused experience.

---

## 🛠 Features

### 🔑 Authorization
- Email and password registration and login  
- Input validation:  
  - ✔️ Email format verification  
  - ✅ Password minimum length of 6 characters  
- Firebase Authentication integration  
- Friendly handling of Firebase errors (e.g., "User already exists", "Invalid password")  
- Successful login redirects to the image gallery  

### ✏️ Drawing Editor
- Canvas with support for:  
  - 🖌️ Brushes of adjustable size and color  
  - 🩹 Eraser  
  - 🎨 Color picker  
- Load images from the device gallery  
- Share drawings via **native share popup**  
- Save drawings to Firebase:  
  - 📤 Upload image files  
  - 🗂 Store metadata (name, date, author)  
  - 🔔 Notify on successful save using `flutter_local_notifications`  

### 🖼 Image Gallery
- Display user images in **grid** or **list**  
- Preview caching for fast loading  
- Tap an image to view or edit in the editor  
- Create a new drawing on an empty canvas  
- Logout option with confirmation dialog in AppBar  

---

## ⚡ Non-Functional Requirements
- Original app name  
- UI fully matches Figma designs (fonts, colors, spacing)  
- Proper use of design logos and icons  
- Clean code with clear separation of logic and state management  
- Navigator 2.0 routing  
- Async operations with `Future` and `Stream`  
- User-friendly error handling  
- Skeleton screens and loaders during data fetch  
- Internet connectivity check  

---

## 🛠 Technologies
- **Platform:** iOS (iPhone)  
- **Language:** Dart  
- **Framework:** Flutter  
- **Database & Storage:** Firebase (Auth, Firestore, Storage)  
- **Notifications:** `flutter_local_notifications`  

---

## 📂 Project Structure
- `lib/` – Main Flutter code  
  - `config/` – App configuration and Firebase initialization  
  - `features/` – Editor, gallery, and authentication modules  
  - `shared/` – Utilities and shared widgets  
- `assets/` – Images, icons, and Figma assets  

---

## 🚀 Installation
```bash
git clone <repository-url>
cd inspira
flutter pub get
flutter run
