#!/bin/bash

# Script to build the RCHAT Flutter application

# Log file
LOG_FILE="/Users/raymondgonzalez/Desktop/build_log.txt"

echo "=========================================" >> "$LOG_FILE"
echo "Build started at $(date)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

# Navigate to the app directory
cd /Users/raymondgonzalez/Documents/rchat || {
  echo "Failed to navigate to rchat directory"
  echo "Failed to navigate to rchat directory" >> "$LOG_FILE"
  exit 1
}

# Clean the project
echo "Cleaning project..." | tee -a "$LOG_FILE"
flutter clean 2>&1 | tee -a "$LOG_FILE"

# Get dependencies
echo "Getting dependencies..." | tee -a "$LOG_FILE"
flutter pub get 2>&1 | tee -a "$LOG_FILE"

# Run code generation (for Drift)
echo "Running code generation..." | tee -a "$LOG_FILE"
flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | tee -a "$LOG_FILE"

# Run tests
echo "Running tests..." | tee -a "$LOG_FILE"
flutter test 2>&1 | tee -a "$LOG_FILE"

# Build Android APK
echo "Building Android APK..." | tee -a "$LOG_FILE"
flutter build apk --release 2>&1 | tee -a "$LOG_FILE"

# Build iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building iOS..." | tee -a "$LOG_FILE"
  flutter build ios --release --no-codesign 2>&1 | tee -a "$LOG_FILE"
fi

echo "=========================================" >> "$LOG_FILE"
echo "Build completed at $(date)" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

# Check for any errors in the log
if grep -q "Error" "$LOG_FILE"; then
  echo "Build completed with errors. See $LOG_FILE for details."
  exit 1
else
  echo "Build completed successfully!"
  exit 0
fi
