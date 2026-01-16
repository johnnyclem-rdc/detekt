#!/bin/bash

# Navigate to the script's directory (SwiftDetekt package root)
cd "$(dirname "$0")"

echo "Cleaning previous build artifacts..."
swift package clean

echo "Building SwiftDetekt (this may take a few minutes)..."
swift build -c release
if [ $? -eq 0 ]; then
    echo "Build successful."
    echo "Installing to /usr/local/bin (requires sudo)..."
    sudo cp .build/release/swiftdetekt /usr/local/bin/swiftdetekt
    echo "Installation complete. You can now run 'swiftdetekt' from anywhere."
else
    echo "Build failed."
    exit 1
fi
