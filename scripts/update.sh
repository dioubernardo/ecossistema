#!/bin/bash

echo "Atualizando ambiente..."

REPO_DIR="$(git rev-parse --show-toplevel)"

# Criando diretório certificados
if [ ! -d "$REPO_DIR/certs" ]; then
  mkdir "$REPO_DIR/certs"
  chmod 600 "$REPO_DIR/certs"
fi

# Gerando chaves do Vault
bash "$REPO_DIR/scripts/vault.sh"

