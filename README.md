# Starter Forge 🔥

A Flutter starter project designed to provide a solid foundation for building scalable and maintainable mobile applications. This project incorporates modern Flutter development practices, including a feature-first architecture, state management with BLoC, service location with GetIt, and declarative routing with GoRouter.

## ✨ Features

*   **Feature-First Architecture:** Code is organized by features for better modularity.
*   **State Management:** Utilizes `flutter_bloc`.
*   **Service Location:** Employs `get_it` for dependency injection.
*   **Routing:** Uses `go_router` for declarative navigation.
*   **Theming:** Includes basic light/dark theme switching.
*   **Linting:** Configured with `flutter_lints` and additional recommended rules.
*   **Example Features:** Counter, Profile, User Details.

## 🚀 Getting Started

### Prerequisites

*   **Flutter SDK:** Version `^3.8.1` (or as specified in `pubspec.yaml`). ([Installation Guide](https://flutter.dev/docs/get-started/install))
*   **Dart SDK:** Bundled with Flutter.
*   An IDE: Android Studio or VS Code (with Flutter/Dart extensions).
*   Emulator/Simulator or a physical device.

### Setup & Installation

1.  **Clone the repository:**
    git clone git@github.com:intlrahul/starter_forge.git cd starter_forge

2.  **Get dependencies:**
    ```bash
    flutter pub get

3. **(If using generated code, e.g., for mocks) Run build_runner:**
   ```bash
    flutter pub run build_runner build --delete-conflicting-outputs

4. **Run the app:**
    ```bash
   flutter run

5. ## 📁 Project Structure

The project follows a feature-first approach:

lib/<br>
├── app/ # App-level setup (main entry, router, service locator)<br>
├── core/ # Shared core functionalities (theme, navigation utils, etc.)<br>
├── features/ # Individual application features<br>
│ ├── dashboard/ # Counter feature<br>
│ │ ├── data/ # Data layer (e.g., API calls, repositories)<br>
│ │ ├── domain/ # Domain layer (e.g., models, use cases)<br>
│ │ └── presentation/ # UI layer (screens, widgets, BLoCs/Cubits)<br>
│ ├── profile/ # Profile feature<br>
│ │ ├── data/<br>
│ │ ├── domain/<br>
│ │ └── presentation/<br>
│ ├── user_details/ # User Details feature<br>
│ │ ├── data/<br>
│ │ ├── domain/<br>
│ │ └── presentation/<br>


## 🧪 Running Tests

*   **Run all tests:**
    ```bash
    flutter test

*   **Generate code coverage:**
    ```bash
    flutter test --coverage # To view HTML report (requires lcov): # genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html

## 🛠️ Key Technologies & Packages

*   **Flutter:** UI toolkit.
*   **`flutter_bloc`:** State management.
*   **`get_it`:** Service locator.
*   **`go_router`:** Declarative routing.
*   **`equatable`:** For value equality.
*   **`google_fonts`:** Custom fonts.
*   **`shared_preferences`:** Simple key-value storage.
*   **`flutter_lints`:** Code linting.
*   **(Testing)** `bloc_test`, `mockito`.

## 📊 Code Quality

*   **Linting:** Enforced via `analysis_options.yaml`. Run `flutter analyze`.
*   **Formatting:** Use `dart format .` to format code.

---



