# User Management App

## Features
- User list with infinite scroll and search
- User details with posts and todos
- Create local posts (persisted with Hive)
- Light/dark theme toggle
- Pull-to-refresh

## Architecture
- **BLoC Pattern**: Separated UI/business logic.
- **Layered Architecture**: Data (API + Hive), Domain (models), Presentation (BLoCs + UI).
- **Dependency Management**: Dio for HTTP, Hive for local storage.

## Setup
1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build` (for Hive codegen)
4. Run `flutter run`
