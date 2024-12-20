#!/bin/sh

# Install dependencies
if [ -d node_modules ]; then
    echo "node_modules already exists. Skipping installation."
else
    echo "Installing dependencies..."
    npm install
fi

"$@"
