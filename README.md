# User Management App

A Flutter application for managing users with infinite scroll, search, offline post creation, and more.

---

## Features

- User list with infinite scroll and search
- User details with posts and todos
- Create local posts (persisted with Hive)
- Light/dark theme toggle
- Pull-to-refresh

---

## Architecture

- **BLoC Pattern:** Separation of UI and business logic for scalability and testability.
- **Layered Architecture:**
  - **Data:** API (DummyJSON) & Hive for local storage
  - **Domain:** Models (User, Post, Todo)
  - **Presentation:** BLoCs, UI screens, and widgets
- **Dependency Management:**
  - Dio for HTTP requests
  - Hive for local storage

---

## Setup
1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build` (for Hive codegen)
4. Run `flutter run`
