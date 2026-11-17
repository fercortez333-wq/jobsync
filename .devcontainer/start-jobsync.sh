#!/usr/bin/env bash
# Starts JobSync inside this Codespace. Runs every time the Codespace starts.
set -e
cd "$(dirname "$0")/.."

# Wait for Docker to be ready
for i in $(seq 1 60); do docker info >/dev/null 2>&1 && break; sleep 2; done

URL="https://${CODESPACE_NAME}-3737.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"

# Create settings once, with fresh secrets. Never overwritten afterwards.
if [ ! -f .env ]; then
  cat > .env <<ENV
TZ=America/Chicago
NEXTAUTH_URL=${URL}
AUTH_TRUST_HOST=true
AUTH_SECRET=$(openssl rand -base64 32)
ENCRYPTION_KEY=$(openssl rand -base64 32)
MCP_ENABLED=true
ENV
fi

docker compose up -d
echo ""
echo "JobSync is starting. Open it here (give it a minute the first time):"
echo "  ${URL}"
