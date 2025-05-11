# RChat Bug Fixes

## 1. Fixed Import Conflict

Fixed name collision between two `Message` classes imported from different sources:
- `package:rchat/src/data/datasources/local/database.dart`
- `package:rchat/src/domain/entities/message.dart`

Solution:
- Used import alias for domain entity: `import '../../../domain/entities/message.dart' as domain;`
- Updated references to use `domain.Message` in the MessageBloc, MessageState, and related files
- This prevents ambiguity when the compiler sees multiple Message class definitions

## 2. Fixed Missing Dependency

Added missing path dependency to pubspec.yaml:
```yaml
path: ^1.8.0
```

## 3. Foreign Key Constraint Fix

Implemented a check to ensure chat threads exist before inserting messages:
- Added `_verifyChatThreadExists` method to check if a thread exists
- Added `_createChatThread` method to create a new thread if needed
- This prevents the foreign key constraint violation: "FOREIGN KEY constraint failed"

The app should now successfully compile and run on Android without the previous errors.
