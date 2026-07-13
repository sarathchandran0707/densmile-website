 #!/bin/bash

echo "Running Densmile Website Tests..."

# Check index.html
if [ ! -f index.html ]; then
    echo "❌ index.html not found"
    exit 1
fi

# Check Dockerfile
if [ ! -f Dockerfile ]; then
    echo "❌ Dockerfile not found"
    exit 1
fi

# Check deployment.yaml
if [ ! -f deployment.yaml ]; then
    echo "❌ deployment.yaml not found"
    exit 1
fi

# Check service.yaml
if [ ! -f service.yaml ]; then
    echo "❌ service.yaml not found"
    exit 1
fi

echo "✅ All required files exist."
exit 0