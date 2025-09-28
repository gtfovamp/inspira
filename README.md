# 🎨 Inspira - Flutter iOS Drawing App

## ✨ Overview

**Inspira** is a modern iOS mobile application built with **Flutter** and **Firebase**. It allows users to register, log in, create and edit drawings on a canvas, import images from the gallery, save and export drawings, and manage images in Firebase. The user interface strictly follows **Figma designs** for a clean and intuitive experience.

---

## 🛠 Features

### 🔑 Authentication
- Email and password registration and login.
- Input validation:
  - ✅ Email format verification
  - ✅ Password minimum length of 6 characters
- Firebase Authentication integration
- Friendly error handling for Firebase responses (e.g., "User already exists", "Invalid password")
- Successful login navigates to the image gallery

### 🎨 Drawing Editor
- Canvas with support for:
  - 🖌 Brush with adjustable size and color
  - 🧹 Eraser
  - 🎨 Color picker
- Import images from device gallery
- Share drawings via **native share popup**
- Save drawings to Firebase:
  - 📤 Upload image files
  - 🗂 Save metadata (name, date, author)
  - 🔔 Notify users on successful save with `flutter_local_notifications`

### 🖼 Image Gallery
- Display user images in **grid** or **list**
- Preview caching for smooth loading
- Tap on image to view or edit in the editor
- Create new drawing on a blank canvas
- Logout option with confirmation dialog in AppBar

---

## ⚡ Non-Functional Requirements
- Original app name
- UI fully matches Figma designs (fonts, spacing, colors)
- Use of logos and icons from the design
- Clean code with proper separation of logic and state management
- Navigator 2.0 for routing
- Async operations with `Future` and `Stream`
- Error handling with user-friendly alerts
- Skeleton screens and loaders during data fetch
- Internet connectivity check

---

## 🧰 Technologies
- **Platform:** iOS (iPhone)  
- **Language:** Dart  
- **Framework:** Flutter  
- **Database & Storage:** Firebase (Auth, Firestore, Storage)  
- **Notifications:** `flutter_local_notifications`

---

## 📂 Project Structure
- `lib/` - Main Flutter source code
  - `config/` - App configuration and Firebase initialization
  - `features/` - Feature modules: editor, gallery, authentication
  - `shared/` - Shared widgets and utility functions
- `assets/` - Images, icons, and Figma resources

---

## 🚀 Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
