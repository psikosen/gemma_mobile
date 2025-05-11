#!/bin/bash

# Script to run the RCHAT Flutter application

# Log file
LOG_FILE="/Users/raymondgonzalez/Desktop/run_log.txt"

# Navigate to the app directory
cd /Users/raymondgonzalez/Documents/rchat || {
  echo "Failed to navigate to rchat directory"
  echo "Failed to navigate to rchat directory" >> "$LOG_FILE"
  exit 1
}

# Run the Flutter app in debug mode
echo "Starting RCHAT app in debug mode..." | tee -a "$LOG_FILE"
flutter run --debug 2>&1 | tee -a "$LOG_FILE"

# Check exit status
if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo "Failed to run RCHAT app" | tee -a "$LOG_FILE"
  exit 1
fi
