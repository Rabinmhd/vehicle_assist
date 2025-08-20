# Parking Management App

A modern Flutter application for managing vehicle parking with user authentication and vehicle management features.

## Features

- **User Authentication**
  - Login functionality
  - Secure token-based authentication
  - Session management

- **Vehicle Management**
  - List all vehicles with pagination
  - Add new vehicles
  - Update vehicle details
  - Delete vehicles
  - Search vehicles by name/number
  - Pull-to-refresh functionality

## Technical Details

### Architecture
- **Clean Architecture** with feature-first folder structure
- **BLoC Pattern** for state management
- **Repository Pattern** for data handling
- **Dependency Injection** using get_it

### Key Dependencies
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `dio`: HTTP client for API calls
- `flutter_screenutil`: Responsive UI
- `shared_preferences`: Local storage

### Project Structure
```
lib/
├── core/
│   ├── api/
│   │   └── api_client.dart
│   └── di/
│       └── injection.dart
└── features/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── vehicle/
        ├── data/
        ├── domain/
        └── presentation/
```

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio/VS Code
- Android SDK with NDK version 27.0.12077973

### Installation

1. Clone the repository
```bash
git clone [repository-url]
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Building Release APK

To build a release APK:
```bash
flutter build apk
```

## Features in Detail

### Authentication
- Secure login system
- Token-based authentication
- Automatic token refresh
- Session persistence

### Vehicle Management
- Create new vehicles with details:
  - Name
  - Vehicle number
  - Color
  - Model
- Update existing vehicle information
- Delete vehicles with confirmation
- Search functionality with debouncing
- Pagination with infinite scroll
- Pull-to-refresh for latest data

## Architecture Details

### BLoC Pattern Implementation
- Separate BLoCs for authentication and vehicle management
- Event-driven state management
- Clean separation of UI and business logic

### API Integration
- RESTful API integration using Dio
- Token interceptors for authentication
- Error handling and response parsing
- Proper loading and error states

### UI/UX Features
- Material Design 3 components
- Responsive layout using flutter_screenutil
- Loading indicators for async operations
- Error handling with user feedback
- Pull-to-refresh functionality
- Infinite scroll for pagination
