# RCHAT

A fully offline, local Flutter chat application with SQLite storage.

## Overview

RCHAT is a private, secure, and fully offline chat application that stores all data locally on your device using SQLite. The application follows Clean Architecture principles and provides a robust, performant chat experience without requiring any internet connectivity.

## Features

- **Fully Offline**: All chat data is stored locally on your device
- **Private & Secure**: Optional database encryption and app passcode protection
- **Chat Threads**: Create and manage multiple conversation threads
- **Search**: Full-text search across all your messages
- **Clean Architecture**: Maintainable and testable codebase
- **Performant**: Efficient handling of large chat histories

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd rchat
   ```

3. Get dependencies:
   ```
   flutter pub get
   ```

4. Run code generation (for Drift):
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```
   flutter run
   ```

### Using the Scripts

The project includes several utility scripts:

- `create_rchat.sh`: Creates the initial project structure
- `build_all.sh`: Builds the application for all platforms
- `run_rchat.sh`: Runs the application in debug mode

Make sure to make the scripts executable before running:
```
chmod +x script_name.sh
```

## Architecture

RCHAT follows Clean Architecture principles with three main layers:

1. **Presentation Layer**: UI components, BLoCs for state management
2. **Domain Layer**: Entities, Use Cases, Repository Interfaces
3. **Data Layer**: Repository Implementations, Local Data Sources

For more details, see the [architecture_plan.md](architecture_plan.md) document.

## Database

RCHAT uses Drift (SQLite) for local data storage with the following key features:

- Relational schema for chat threads and messages
- Full-text search using SQLite's FTS5
- Optional encryption via SQLCipher
- Efficient querying and pagination

For more details, see the [database_specification.md](database_specification.md) document.

## Security

- All data is stored locally on the device
- Optional database encryption using SQLCipher
- Optional app passcode protection
- Secure key derivation using PBKDF2

## Testing

The project includes:

- Unit tests for repositories and use cases
- Widget tests for UI components
- Integration tests for database operations
- Performance tests for large datasets

Run the tests with:
```
flutter test
```

## License

[Insert License Information]

## Acknowledgements

- Drift package for SQLite integration
- Flutter and Dart teams for the amazing framework
