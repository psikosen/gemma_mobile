# RChat App Changes

## 1. Bug Fix: Message Sending Issue

Fixed a foreign key constraint error when sending messages. The issue was that messages were being inserted with thread IDs that didn't exist in the ChatThreads table.

Changes:
- Modified the MessageBloc to check if a thread exists before inserting a message
- Added a function to create a new thread if it doesn't exist
- This ensures the foreign key constraint is satisfied

## 2. Added AI Model Management

Added functionality to download and manage AI models from Hugging Face.

### Features:
- List of available models with descriptions and sizes
- Model download with progress indication
- Model deletion functionality
- Support for multiple models:
  - Gemma 2B-IT
  - Gemma3 1B-IT
  - DeepSeek R1 Distill Qwen 1.5B
  - Phi-4 Mini Instruct

### Implementation Details:
- Added a dedicated "AI Models" section in the Settings page
- Created a Model Management page to browse and download models
- Added a download progress indicator component
- Created a BLoC architecture for model management
- Implemented the AIModel class for model data

### How to Use:
1. Go to Settings
2. Tap on "Manage AI Models" in the AI Models section
3. Browse available models
4. Tap the download icon to download a model
5. Tap the delete icon to remove a downloaded model

### Technical Notes:
- Models are stored in the application documents directory
- The flutter_gemma package is used for Gemma model integration
- Other models are supported through their custom implementations
- Currently, the actual model downloading is stubbed with progress simulation
- In a production app, this would be connected to the Hugging Face API

## Future Improvements:
- Implement actual model downloading from Hugging Face API
- Add model usage in the chat interface
- Add model selection functionality 
- Provide offline capabilities for downloaded models
- Add model version management
