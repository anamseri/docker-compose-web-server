#!/bin/bash
set -e

ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "File .env not found in $(pwd)"
    exit 1
fi

# Load env safely
set -a
source "$ENV_FILE"
set +a

if [ -z "$PROJECT_DIR" ]; then
    echo "Please set PROJECT_DIR in .env"
    exit 1
fi

USER_NAME="$USER"
# SSL_KEY="$PROJECT_DIR/nginx/certbot/live/localhost/privkey.pem"
# SSL_CERT="$PROJECT_DIR/nginx/certbot/live/localhost/fullchain.pem"

echo "Set ownership to user: $USER_NAME"
sudo chown -R $USER_NAME:$USER_NAME "$PROJECT_DIR"

echo "Set directory permissions: 755"
sudo find "$PROJECT_DIR" -type d -exec chmod 755 {} \;

echo "Set file permissions: 644"
sudo find "$PROJECT_DIR" -type f -exec chmod 644 {} \;

echo "Set permission .env: 600"
# chmod 600 .env
chmod 600 "$ENV_FILE"

# echo "Set permission SSL private key: 600"
# [ -f "$SSL_KEY" ] && chmod 600 "$SSL_KEY"

# echo "Set permission SSL public certificate: 644"
# [ -f "$SSL_CERT" ] && chmod 644 "$SSL_CERT"

echo "Permissions setup complete!."