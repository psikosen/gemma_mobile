# RCHAT Application Development TODO List

## Initial Setup
- [x] Create a TODO list
- [x] Execute create_rchat.sh script to initialize Flutter project
- [x] Verify project structure and dependencies

## Core Database Implementation
- [x] Set up basic project directory structure following Clean Architecture
- [x] Create core Drift database file
- [x] Define database tables (threads, messages)
- [x] Implement DAOs (Data Access Objects)
- [x] Implement repository interfaces in domain layer
- [x] Implement repositories in data layer
- [x] Add security features (encryption) - Implemented in database.dart with SecurityService
- [ ] Write unit tests for repositories

## Domain Layer Implementation
- [x] Create domain entities (Message, ChatThread)
- [x] Define use case interfaces
- [x] Implement core use cases:
  - [x] GetChatThreadsUseCase
  - [x] GetMessagesForThreadUseCase
  - [x] SaveMessageUseCase
  - [x] SearchMessagesUseCase
- [ ] Add unit tests for use cases

## Presentation Layer Setup
- [x] Set up dependency injection (simple ServiceLocator)
- [x] Set up BLoC pattern for state management
- [x] Create ChatThreadBloc
- [x] Create MessageBloc
- [x] Design basic UI components
  - [x] ChatThreadItem widget
  - [x] MessageBubble widget
- [x] Create navigation structure
  - [x] ChatThreadsPage
  - [x] MessagePage

## Feature Implementation
- [x] Implement ChatThreadListPage
- [x] Implement MessagePage
- [x] Add message sending functionality
- [x] Add message loading with pagination
- [x] Implement search functionality
  - [x] Create SearchPage
  - [x] Use SearchMessagesUseCase
  - [x] Add navigation to MessagePage from search results
- [x] Add optional passcode protection
  - [x] Create SecurityService
  - [x] Add passcode setup and verification screens
  - [x] Implement biometric authentication
  - [x] Add settings page with security options
  - [x] Update database to use encryption key

## Testing and Polishing
- [ ] Add integration tests
- [ ] Test app restart and data persistence
- [ ] Optimize performance for large datasets
- [ ] Add animations and transitions
- [ ] Ensure responsive layout

## Build and Deployment
- [ ] Set up CI/CD configuration
- [ ] Configure automated testing in pipeline
- [ ] Optimize build size
