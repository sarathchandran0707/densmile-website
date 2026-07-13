#!/bin/bash

echo "Running Densmile Website Tests..."

# Check if index.html exists
if [ ! -f "index.html" ]; then
  echo "❌ index.html not found"
  exit 1
fi

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
  echo "❌ Dockerfile not found"
  exit 1
fi

echo "✅ All tests passed!"
exit 0