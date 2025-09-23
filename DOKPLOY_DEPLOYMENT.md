# Dokploy Deployment Guide

This guide explains how to deploy xiaozhi-esp32-server on Dokploy with proper configuration management.

## Prerequisites

- Dokploy instance running
- Access to Dokploy dashboard
- Manager API deployed and accessible

## Deployment Methods

### Method 1: Using Environment Variables (Recommended)

1. **Set Environment Variables in Dokploy:**
   - Go to your application settings in Dokploy
   - Add the following environment variables:

   ```
   MANAGER_API_SECRET=your-actual-secret-from-manager-api
   SERVER_IP=0.0.0.0
   SERVER_PORT=8000
   SERVER_HTTP_PORT=8003
   MANAGER_API_URL=http://xiaozhi-esp32-server-web:8002/xiaozhi
   SERVER_VISION_EXPLAIN=http://xiaozhi-esp32-server-web:8002/mcp/vision/explain
   MYSQL_ROOT_PASSWORD=123456
   MYSQL_DATABASE=xiaozhi_esp32_server
   ```

2. **Add Build Command:**
   In Dokploy, set the build command to:
   ```bash
   chmod +x deploy.sh && ./deploy.sh
   ```

3. **Deploy:**
   - Use the main `docker-compose.yml` file
   - The deployment script will generate `data/.config.yaml` automatically

### Method 2: Using Docker Compose Override

1. **Set Environment Variables** (same as Method 1)

2. **Use Override File:**
   In Dokploy, set the Docker Compose file to:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.dokploy.yml up -d
   ```

### Method 3: Manual Configuration File

1. **Create Config File Manually:**
   - Before deployment, create the `data/.config.yaml` file
   - Copy the content from `data/.config.yaml` in this repository
   - Update the `manager-api.secret` value with your actual secret

2. **Upload to Dokploy:**
   - Include the `data` directory in your deployment

## Getting the Manager API Secret

1. Deploy and start the manager-api service first
2. Access the web interface at `http://your-domain:8002/`
3. Register an admin account (first user becomes admin)
4. Navigate to: **Parameters Management** → **Parameter Dictionary**
5. Find parameter: `server.secret`
6. Copy the value and use it as `MANAGER_API_SECRET`

## Verification

After deployment, verify the configuration:

1. **Check Container Logs:**
   ```bash
   docker logs xiaozhi-esp32-server
   ```

2. **Verify Config File:**
   ```bash
   docker exec xiaozhi-esp32-server cat /opt/xiaozhi-esp32-server/data/.config.yaml
   ```

3. **Test Endpoints:**
   - WebSocket: `ws://your-domain:8000/xiaozhi/v1/`
   - HTTP API: `http://your-domain:8003/mcp/vision/explain`
   - Web Interface: `http://your-domain:8002/`

## Troubleshooting

### Config File Not Found
- Ensure the `deploy.sh` script ran successfully
- Check that `MANAGER_API_SECRET` environment variable is set
- Verify the `data` directory has correct permissions

### Connection Issues
- Verify all services are running: `docker ps`
- Check network connectivity between containers
- Ensure ports are properly exposed in Dokploy

### Secret Mismatch
- Regenerate the secret in manager-api parameter management
- Update the `MANAGER_API_SECRET` environment variable
- Restart the xiaozhi-esp32-server container

## Security Notes

- Keep `MANAGER_API_SECRET` secure and don't commit it to version control
- Use strong passwords for `MYSQL_ROOT_PASSWORD`
- Consider using Docker secrets for production deployments
- Regularly rotate the manager API secret