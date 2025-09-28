???? Inspira - Flutter.Drawing App for iOS

## ✨ Synopsis
The
A.

**Inspira** is a newer iOS mobile app developed using **Flutter** and **Firebase**. You can register and login, create and modify drawings on a canvas, add images from the device's gallery, save and export drawings and modify images in **Firebase**. **Figma designs** are strictly adhered to for a minimalist and user-obsessed user experience.

---

## ???? Features

### ???? Authorization
We
- Sign-up and login through email and password.
- Input validation:
- ✔️ Check for email structure verification
- ✅ Password of minimum 6 character length
- Firebase Authentication integration
- Friendly error handling of the error messages from Firebase (e.g., "User already exists", "Invalid password")
- Successful login to picture gallery

### ???? Drawing Editor
The
- Canvas without support for:
- ???? Brushes of variable size and color
- ???? Eraser
- ???? Colour picker
- Load pictures from device photo library
-Sharing of sketches through **native share popup**
- Save drawings to Firebase:
- ???? Upload picture files
- ???? Keep metadata (name, date, writer)
- ???? Notify on successful saving using `flutter_local_notifications`

### ???? Image Collection
- Show user images in **grid** or **list**
- Preview caching for seamless loading
-Tap on photo to open or edit in editor
- Produce a painting on a newly unused canvas
- Logout option on confirmation dialog in AppBar

---

## ⚡ Non-Functional Requirements
- Original application's name
- UI completely corresponds to Figma designs (fonts, padding, colors)
- Logos and symbols of the implemented design
- Proper logic with well-structured coding and encapsulation of the state management
- Navigator 2.0 with routing
- Async actions with `Future` and `Stream`
- Handling mistakes with friendly alerts
-Skeleton screens and data loaders on data loading
- Internet connectivity check

---

## ???? Technologies
- **Platform:** iOS (iPhone)
- **Language:** Dart - **Platform:** Flutter

- **Database & Storage:** Firebase (Auth, Firestore, Storage)

- **Notifications:** `flutter

---

## ????️ Directory Structure - `lib/` - Основной код Flutter'app - `config/` - Application configuration and Firebase initialization - `features/` - Editor, galleries and login Features modules - `shared/` -Util functions and Shared widgets - `assets/` - Bilder, Iconen und Figma- --- ## ???? Installation 1. Kopieren des Repositorien: #./ git clone <url-of-the
