# Starter Forge 🔥

A **production-ready Flutter starter template** designed to provide a comprehensive foundation for building scalable and maintainable cross-platform applications. This project incorporates modern Flutter development practices, clean architecture, and a complete set of infrastructure components.

## ✨ Features

### 🏗️ **Architecture & Patterns**
- **Clean Architecture**: Complete separation with data, domain, and presentation layers
- **Feature-First Organization**: Modular structure for unlimited scalability
- **BLoC State Management**: Predictable state management with `flutter_bloc`
- **Dependency Injection**: Service locator pattern using `get_it`
- **Result Pattern**: Type-safe error handling with Freezed
- **Repository Pattern**: Abstracted data access layer

### 🌐 **Network & API**
- **HTTP Client**: Configured Dio client with interceptors
- **Error Handling**: Centralized network exception handling
- **Authentication**: JWT token management with auto-refresh
- **Connectivity Monitoring**: Real-time network status tracking
- **Request/Response Logging**: Comprehensive network debugging

### 💾 **Data & Storage**
- **Local Storage**: Hive-based key-value storage
- **Secure Storage**: Encrypted storage for sensitive data
- **Caching**: Multi-layered caching strategy
- **Data Persistence**: Automatic data synchronization

### 🎨 **UI & Theming**
- **Material Design 3**: Latest design system implementation
- **Dynamic Theming**: Light/dark/system theme support
- **Custom Components**: Pre-built, reusable UI widgets
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Google Fonts**: Typography system with Lato font family

### 🌍 **Internationalization**
- **Multi-language Support**: ARB-based localization
- **RTL Support**: Right-to-left language compatibility
- **Dynamic Language Switching**: Runtime language changes

### 🔒 **Security & Validation**
- **Input Validation**: Comprehensive form validation framework
- **Secure Storage**: Biometric authentication support
- **Environment Configuration**: Secure environment variable management

### 📊 **Analytics & Monitoring**
- **Analytics Framework**: Pluggable analytics service architecture
- **Error Tracking**: Centralized error reporting
- **Performance Monitoring**: App performance metrics
- **User Journey Tracking**: Detailed user interaction analytics

### 🧪 **Testing & Quality**
- **Unit Tests**: Comprehensive test coverage
- **Widget Tests**: UI component testing
- **BLoC Testing**: State management testing
- **Code Generation**: Freezed for immutable data classes
- **Linting**: Strict code quality enforcement

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version `^3.8.1` ([Installation Guide](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: Bundled with Flutter
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Platform Tools**: Xcode (iOS), Android Studio (Android)

### Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd starter_forge
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Environment Configuration

Create environment-specific configurations:

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev --dart-define=BASE_URL=https://api-dev.example.com

# Staging
flutter run --dart-define=ENVIRONMENT=staging --dart-define=BASE_URL=https://api-staging.example.com

# Production
flutter run --dart-define=ENVIRONMENT=prod --dart-define=BASE_URL=https://api.example.com
```

## 📁 Project Structure

```
lib/
├── app/                          # App-level configuration
│   ├── router/                   # Navigation setup
│   └── service_locator.dart      # Dependency injection
├── core/                         # Shared core functionalities
│   ├── analytics/                # Analytics service
│   ├── config/                   # Environment configuration
│   ├── error/                    # Error handling patterns
│   ├── logging/                  # Logging service
│   ├── network/                  # HTTP client & connectivity
│   ├── storage/                  # Local & secure storage
│   ├── theme/                    # App theming system
│   ├── utils/                    # Utilities & constants
│   ├── validation/               # Form validation
│   └── widgets/                  # Reusable UI components
├── features/                     # Business features
│   ├── dashboard/               # Main dashboard feature
│   │   ├── data/               # Data sources & repositories
│   │   ├── domain/             # Business logic & entities
│   │   └── presentation/       # UI, BLoCs, and screens
│   ├── profile/                # User profile management
│   └── user_details/           # User details management
├── generated/                   # Generated code (l10n, etc.)
└── l10n/                       # Localization files
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🛠️ Key Technologies & Packages

### **Core Dependencies**
- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `go_router` - Declarative routing
- `dio` - HTTP client
- `hive` - Local storage
- `flutter_secure_storage` - Secure storage

### **UI & Design**
- `google_fonts` - Typography
- `connectivity_plus` - Network monitoring
- Material Design 3 - Design system

### **Development Tools**
- `freezed` - Code generation for data classes
- `json_serializable` - JSON serialization
- `build_runner` - Code generation
- `flutter_lints` - Code quality

### **Testing**
- `bloc_test` - BLoC testing
- `mocktail` - Mocking framework

## 🎯 Core Components

### **HTTP Client**
```dart
final client = sl<DioClient>();
final response = await client.get('/api/users');
```

### **Local Storage**
```dart
// Simple key-value storage
await LocalStorage.setAppData('key', 'value');
final value = LocalStorage.getAppData<String>('key');

// Secure storage for sensitive data
await sl<SecureStorage>().setAccessToken(token);
```

### **Analytics**
```dart
// Track events
sl<AnalyticsManager>().trackEvent('button_clicked', parameters: {
  'button_name': 'sign_up',
  'screen': 'home',
});

// Track screen views
sl<AnalyticsManager>().trackScreenView('home');
```

### **Connectivity**
```dart
// Monitor connectivity
sl<ConnectivityService>().connectionStream.listen((isConnected) {
  if (isConnected) {
    // Handle online state
  } else {
    // Handle offline state
  }
});
```

### **Custom Widgets**
```dart
// Enhanced button with loading states
AppButton(
  text: 'Submit',
  variant: AppButtonVariant.primary,
  isLoading: isSubmitting,
  onPressed: () => _handleSubmit(),
)

// Enhanced text field with validation
AppTextField(
  label: 'Email',
  validator: Validators.email,
  onChanged: (value) => _handleEmailChanged(value),
)
```

## 📊 Code Quality

- **Linting**: Enforced via `analysis_options.yaml`
- **Formatting**: Use `dart format .`
- **Analysis**: Run `flutter analyze`
- **Architecture**: Clean Architecture principles
- **Testing**: Comprehensive test coverage

## 🚢 Deployment

### **Build Commands**
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

### **Environment Variables**
Set these in your CI/CD pipeline:
- `ENVIRONMENT` - dev/staging/prod
- `BASE_URL` - API base URL
- `ENABLE_ANALYTICS` - Analytics toggle
- `ENABLE_LOGGING` - Logging toggle

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Open source community for the excellent packages

---

**Built with ❤️ for the Flutter community**

*This starter template provides everything you need to build production-ready Flutter applications with clean architecture, comprehensive testing, and modern development practices.*