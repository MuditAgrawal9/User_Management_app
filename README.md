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

1. Clone the repo:
    ```
    git clone https://github.com/your-username/user_management_app.git
    cd user_management_app
    ```
2. Install dependencies:
    ```
    flutter pub get
    ```
3. Generate Hive adapters:
    ```
    flutter pub run build_runner build
    ```
4. Run the app:
    ```
    flutter run
    ```

