# RCHAT Architecture Plan

## Overview
RCHAT is a fully offline, local chat application built with Flutter and SQLite (using Drift). The application follows Clean Architecture principles to ensure separation of concerns, testability, and maintainability.

## Architecture Layers

### 1. Presentation Layer
- **UI Components**: Flutter widgets for displaying the chat interface, threads, and settings
- **State Management**: Using BLoC pattern for managing application state
- **Pages/Screens**: Main screens of the application
- **View Models**: Prepare data for presentation in the UI

### 2. Domain Layer
- **Entities**: Core business objects (Message, ChatThread)
- **Use Cases**: Application-specific business rules
- **Repository Interfaces**: Abstract definitions for data operations
- **Value Objects**: Immutable objects with validation logic

### 3. Data Layer
- **Repositories**: Implementations of repository interfaces defined in Domain layer
- **Local Data Sources**: Interface with SQLite database through Drift
- **DTOs**: Data Transfer Objects for mapping between domain entities and database models
- **Database**: Drift SQLite implementation

## Data Flow
1. User interacts with the UI (Presentation Layer)
2. Events are dispatched to BLoCs (Presentation Layer)
3. BLoCs call appropriate Use Cases (Domain Layer)
4. Use Cases execute business logic using Repository interfaces (Domain Layer)
5. Repositories retrieve/store data through Local Data Sources (Data Layer)
6. Data flows back through the layers, with appropriate transformations at each boundary

## Database Schema

### Tables

#### ChatThread
- `thread_id`: TEXT PRIMARY KEY
- `name`: TEXT
- `last_message_timestamp`: INTEGER NOT NULL
- `unread_count`: INTEGER NOT NULL DEFAULT 0

#### Message
- `message_id`: TEXT PRIMARY KEY
- `thread_id`: TEXT NOT NULL, REFERENCES threads(thread_id)
- `sender_id`: TEXT NOT NULL
- `content`: TEXT NOT NULL
- `timestamp`: INTEGER NOT NULL
- `status`: TEXT NOT NULL DEFAULT 'saved'
- `message_type`: TEXT NOT NULL DEFAULT 'text'
- `local_file_path`: TEXT

### Indexes
- `idx_messages_thread_timestamp`: ON messages (thread_id, timestamp DESC)
- FTS5 virtual table for message content search

## Security
- Database encryption using SQLCipher
- Optional application passcode protection
- Secure key derivation using PBKDF2

## Folder Structure
```
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── error/
    │   ├── utils/
    │   └── constants/
    ├── data/
    │   ├── datasources/
    │   │   └── local/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

## Core Features
1. Create and manage chat threads
2. Send and receive messages (text only initially)
3. Search messages within threads
4. Optional passcode protection
5. Database encryption

## Performance Considerations
- Efficient pagination for message loading
- Proper indexing for fast message retrieval
- Optimized list rendering using ListView.builder
- Background processing for intensive operations using Isolates

## Testing Strategy
- Unit tests for repositories and use cases
- Widget tests for UI components
- Integration tests for database operations
- Performance tests for large datasets
