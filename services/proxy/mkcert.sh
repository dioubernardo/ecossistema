#!/bin/sh

if [ ! -f /certs/local.crt ] || [ ! -f /certs/local.key ]; then
  echo ">> Gerando certificado self-signed para *.local..."
  openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 3650 \
    -keyout /certs/local.key \
    -out /certs/local.crt \
    -subj "/CN=*.local" \
    -addext "subjectAltName=DNS:*.local,DNS:local,IP:127.0.0.1"
fi

exec "$@"