#!/bin/bash

# Script to run build_runner for code generation

# Navigate to the app directory
cd /Users/raymondgonzalez/Documents/rchat || {
  echo "Failed to navigate to rchat directory"
  exit 1
}

# Use the Flutter SDK found in the run_rchat.sh script
if [ -f "/Users/raymondgonzalez/development/flutter/bin/flutter" ]; then
  FLUTTER_CMD="/Users/raymondgonzalez/development/flutter/bin/flutter"
elif [ -f "/Users/raymondgonzalez/fvm/versions/3.29.2/bin/flutter" ]; then
  FLUTTER_CMD="/Users/raymondgonzalez/fvm/versions/3.29.2/bin/flutter"
else
  echo "Flutter SDK not found. Please update the script with the correct path."
  exit 1
fi

echo "Using Flutter command: $FLUTTER_CMD"
echo "Running build_runner to generate Drift database code..."

$FLUTTER_CMD pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
  echo "✅ Code generation completed successfully!"
else
  echo "❌ Code generation failed."
  exit 1
fi
