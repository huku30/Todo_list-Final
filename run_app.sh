#!/bin/bash

# Run Flutter Todo App on Pixel_9a Emulator
# This script launches the emulator and runs the app

set -e

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR"

echo "🚀 Starting Pixel_9a emulator..."
flutter emulators --launch Pixel_9a &
EMULATOR_PID=$!

echo "⏳ Waiting for emulator to start (10 seconds)..."
sleep 10

echo "📱 Checking connected devices..."
flutter devices

echo "🎯 Running Flutter app on emulator..."
flutter run -d emulator-5554

wait $EMULATOR_PID 2>/dev/null || true
