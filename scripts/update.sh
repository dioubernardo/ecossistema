#!/bin/bash

echo "Atualizando ambiente..."

REPO_DIR="$(git rev-parse --show-toplevel)"

cd $REPO_DIR

# Configurando git-hooks
git config core.hooksPath .git-hooks

# Corrigindo permissões
chmod +x .git-hooks/* scripts/*

# Criando diretório certificados
if [ ! -d certs ]; then
  mkdir certs
  chmod 600 certs
fi

# Gerando chaves do Vault
scripts/vault.sh
