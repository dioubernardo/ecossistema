#!/bin/sh

if [ ! -f /certs/rootCA.crt ]; then
  echo ">> Gerando rootCA..."
  openssl genrsa -out /certs/rootCA.key 4096
  openssl req -x509 -new -nodes -key /certs/rootCA.key -sha256 -days 3650 \
    -out /certs/rootCA.crt \
    -subj "/CN=MyLocal Root CA"
fi

if [ ! -f /certs/local.crt ] || [ ! -f /certs/local.key ]; then

  echo ">> Gerando certificado self-signed para *.$DOMINIO..."
  openssl req -new -newkey rsa:2048 -nodes \
    -keyout /certs/local.key \
    -out /certs/local.csr \
    -subj "/CN=*.$DOMINIO" \
    -addext "subjectAltName=DNS:*.$DOMINIO,DNS:$DOMINIO"

  echo ">> Assinando certificado *.$DOMINIO com rootCA..."
  openssl x509 -req -in /certs/local.csr \
    -CA /certs/rootCA.crt -CAkey /certs/rootCA.key -CAcreateserial \
    -out /certs/local.crt -days 825 -sha256 \
    -extfile <(printf "subjectAltName=DNS:*.$DOMINIO,DNS:$DOMINIO")

  rm /certs/*.csr
  rm /certs/*.srl

fi

exec "$@"