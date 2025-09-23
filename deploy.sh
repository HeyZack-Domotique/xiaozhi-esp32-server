#!/bin/bash

# Deployment script for xiaozhi-esp32-server on Dokploy
# This script generates the data/.config.yaml file from environment variables

set -e

echo "Starting xiaozhi-esp32-server deployment configuration..."

# Create data directory if it doesn't exist
mkdir -p data

# Set default values if not provided
SERVER_IP=${SERVER_IP:-"0.0.0.0"}
SERVER_PORT=${SERVER_PORT:-"8000"}
SERVER_HTTP_PORT=${SERVER_HTTP_PORT:-"8003"}
SERVER_VISION_EXPLAIN=${SERVER_VISION_EXPLAIN:-"http://xiaozhi-esp32-server-web:8002/mcp/vision/explain"}
MANAGER_API_URL=${MANAGER_API_URL:-"http://xiaozhi-esp32-server-web:8002/xiaozhi"}

# Check if required environment variables are set
if [ -z "$MANAGER_API_SECRET" ]; then
    echo "Error: MANAGER_API_SECRET environment variable is required"
    echo "Please set it in your Dokploy environment variables"
    exit 1
fi

# Generate .config.yaml file
cat > data/.config.yaml << EOF
# Configuration file for xiaozhi-esp32-server
# Generated automatically during deployment

server:
  ip: ${SERVER_IP}
  port: ${SERVER_PORT}
  # HTTP service port, used for vision analysis interface
  http_port: ${SERVER_HTTP_PORT}
  # Vision analysis interface address
  vision_explain: ${SERVER_VISION_EXPLAIN}

manager-api:
  # Manager-api address
  url: ${MANAGER_API_URL}
  # Manager-api secret token
  secret: ${MANAGER_API_SECRET}
EOF

echo "Configuration file generated successfully at data/.config.yaml"
echo "Configuration:"
echo "  Server IP: ${SERVER_IP}"
echo "  Server Port: ${SERVER_PORT}"
echo "  HTTP Port: ${SERVER_HTTP_PORT}"
echo "  Manager API URL: ${MANAGER_API_URL}"
echo "  Vision Explain URL: ${SERVER_VISION_EXPLAIN}"

# Make sure the file has correct permissions
chmod 644 data/.config.yaml

echo "Deployment configuration completed successfully!"
