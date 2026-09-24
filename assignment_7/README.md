# 📱 Assignment 7 – 3-Screen App with Named Routes & Form Validation

A complete Flutter application demonstrating **Declarative Named Route Navigation** across three dedicated screens (**Home**, **Form**, and **Detail**) paired with **Comprehensive Form Validation** using `GlobalKey<FormState>`, custom `FormField` validation, and route argument passing.

**Name:** Pranav Kale  
**Roll No:** 150096724142  

---

## 📋 Table of Contents

- [Features](#-features)
- [Screens & Navigation Flow](#-screens--navigation-flow)
- [Project Structure](#-project-structure)
- [Architecture Overview](#-architecture-overview)
- [Validation Rules](#-validation-rules)
- [Concepts Used](#-concepts-used)
- [How to Run](#-how-to-run)
- [Code Walkthrough](#-code-walkthrough)
- [Challenges & Solutions](#-challenges--solutions)

---

## ✨ Features

- **3-Screen Architecture**:
  - **Screen 1 (Home)**: Welcoming dashboard with feature breakdown, quick action CTAs, and a sample data preview.
  - **Screen 2 (Form)**: High-performance registration form with real-time feedback, password show/hide toggles, account role dropdown, gender selector, newsletter switch, and terms checkbox.
  - **Screen 3 (Detail)**: User profile dashboard extracting data dynamically from route arguments, with initials avatar, status badge, formatted timestamp, masked password, and return navigation.
- **Named Route Navigation**:
  - Centralized route registry in `app_routes.dart` (`'/'`, `'/form'`, `'/detail'`).
  - Seamless data passing via `Navigator.pushNamed(context, '/detail', arguments: userData)`.
  - Stack clearing via `Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)`.
- **Stringent Input Validation**:
  - **Full Name**: Required, length ≥ 3, alphabetic characters only.
  - **Email Address**: Regex pattern matching (`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`).
  - **Phone Number**: Required 10-digit numeric format.
  - **Password**: Minimum 8 characters with at least one alphabet and one digit.
  - **Confirm Password**: Real-time matching against password field.
  - **Terms Checkbox**: Required field enforced via `FormField<bool>`.
- **Material 3 Design**: Clean Indigo color scheme, elevated cards, outlined input fields, responsive scrolling, and polished badges.
- **Zero Lint Warnings**: Fully complies with Flutter's recommended lints.

---

## 🗺️ Screens & Navigation Flow

```
┌────────────────────────────────────────────────────────┐
│                   HomeScreen ('/')                     │
│  • Hero Banner & App Overview                          │
│  • "Go to Registration Form" CTA                       │
│  • "View Sample Detail Screen" preview CTA             │
└───────────────┬─────────────────────────┬──────────────┘
                │                         │
  pushNamed('/form')          pushNamed('/detail', sampleData)
                │                         │
                ▼                         ▼
┌──────────────────────────────┐    ┌───────────────────────────────────┐
│     FormScreen ('/form')     │    │       DetailScreen ('/detail')    │
│  • Full Name Input           │    │  • Initials Avatar (e.g. 'PK')    │
│  • Email Input (Regex)       │    │  • Profile Header & Status Badge  │
│  • Phone Input (10 Digits)   │    │  • Full User Details Display      │
│  • Password & Confirm Inputs │───▶│  • Masked Password Security Tile  │
│  • Role Dropdown & Gender    │    │  • "Return to Home" Action        │
│  • Terms Checkbox (Required) │    │  • "Edit Details" Action (pop)    │
│  • Submit Button             │    └───────────────────────────────────┘
└──────────────────────────────┘
```

---

## 📁 Project Structure

```
assignment_7/ (Branch)
├── lib/
│   ├── main.dart                      # Application entry point, MaterialApp & theme setup
│   ├── models/
│   │   └── user_registration.dart     # Immutable model holding validated registration data
│   ├── routes/
│   │   └── app_routes.dart            # Route names constants & named routes map
│   ├── screens/
│   │   ├── home_screen.dart           # Screen 1: Dashboard & Navigation hub
│   │   ├── form_screen.dart           # Screen 2: Registration Form with Form & FormField validation
│   │   └── detail_screen.dart         # Screen 3: User Details / Profile display
│   └── widgets/
│       ├── custom_text_field.dart     # Reusable text form field widget
│       └── detail_info_row.dart       # Reusable key-value row widget
└── README.md                          # Comprehensive project documentation
```

---

## 🏗️ Architecture Overview

```
┌────────────────────────────────────────────────────────────────────────┐
│                               main.dart                                │
│                   MaterialApp + Material 3 Theme                       │
│                                   │                                    │
│                   ┌───────────────┴───────────────┐                    │
│                   ▼                               ▼                    │
│          app_routes.dart                  user_registration.dart       │
│  ┌──────────────────────────────┐    ┌──────────────────────────────┐  │
│  │ static const home = '/'      │    │ class UserRegistration       │  │
│  │ static const form = '/form'  │    │ • fullName, email, phone     │  │
│  │ static const detail ='/detail'│   │ • password, accountType      │  │
│  └──────────────┬───────────────┘    │ • initials, formattedDate    │  │
│                 │                    └──────────────┬───────────────┘  │
│                 ▼                                   │                  │
│       ┌───────────────────┬───────────────────┐     │                  │
│       ▼                   ▼                   ▼     │                  │
│  home_screen.dart   form_screen.dart   detail_screen.dart              │
│  [Screen 1]         [Screen 2]         [Screen 3] ◀─┘                  │
│                     ┌──────────┴──────────┐                            │
│                     ▼                     ▼                            │
│            custom_text_field.dart  detail_info_row.dart                │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🔍 Validation Rules

| Field | Rule Description | Pattern / Condition |
|:---|:---|:---|
| **Full Name** | Required, min 3 characters, alphabets only | `RegExp(r"^[a-zA-Z\s.'-]+$")` |
| **Email Address** | Required, valid email format | `RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')` |
| **Phone Number** | Required, 10 numeric digits | `RegExp(r'^\d{10}$')` |
| **Password** | Required, min 8 characters, letters & digits | `value.length >= 8 && RegExp(r'[A-Za-z]').hasMatch && RegExp(r'\d').hasMatch` |
| **Confirm Password** | Required, must match primary password | `value == _passwordController.text` |
| **Terms Checkbox** | Required user acceptance | `_agreeToTerms == true` |

---

## 💡 Concepts Used

1. **`Navigator.pushNamed` & `Navigator.pushNamedAndRemoveUntil`**: Centralized, type-safe route management using Flutter's named routes table.
2. **`ModalRoute.of(context)!.settings.arguments`**: Passing complex structured data objects across screens without coupling constructors.
3. **`GlobalKey<FormState>`**: Synchronous form evaluation triggering all nested field validators simultaneously.
4. **`AutovalidateMode.onUserInteraction`**: Dynamic UI validation providing immediate feedback as user inputs information.
5. **Custom `FormField<bool>`**: Encapsulating non-text interactive widgets (like Checkbox) with standard form validation rules.
6. **Immutable Data Model**: `UserRegistration` model holding user data, computing initials, and formatting timestamps safely.

---

## 🚀 How to Run

1. Clone this repository and checkout the `assignment_7` branch:
   ```bash
   git clone https://github.com/Pranavk1105/Flutter-Assignments.git
   cd Flutter-Assignments
   git checkout assignment_7
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run the application on your preferred device:
   ```bash
   flutter run
   ```

---

## 🛠️ Challenges Faced & Solutions

- **Validating Non-Text Elements (Checkbox)**: Checkboxes are not standard `TextFormField`s. Solved by wrapping them with `FormField<bool>`, allowing seamless integration with `_formKey.currentState!.validate()`.
- **Route Argument Null-Safety**: Prevented crashes when navigating directly without arguments by adding defensive null checks and a fallback UI with redirection.
- **Dynamic Password Confirmation**: Kept password and confirm password fields synchronized using real-time validation checks.
