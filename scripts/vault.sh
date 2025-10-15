#!/bin/bash

REPO_DIR="$(git rev-parse --show-toplevel)"

if [ ! -f "$REPO_DIR/.env" ]; then
  echo "Arquivo .env não existe."
  exit 0
fi

if [ ! -f "$REPO_DIR/vault.config" ]; then
  echo "Arquivo vault.config não existe."
  exit 0
fi

source "$REPO_DIR/.env"

MARKER="#### VAULT #### Não modificar abaixo deste ponto"

# Monta a nova seção
NEW_SECTION=""
while IFS= read -r VAR_NAME || [ -n "$VAR_NAME" ]; do
    VAR_NAME="${VAR_NAME%$'\r'}"
    [[ -z "$VAR_NAME" || "$VAR_NAME" =~ ^# ]] && continue
    VALUE=${!VAR_NAME}
    if [ -z "$VALUE" ]; then
        VALUE="$(openssl rand -hex 16)"
    fi
    NEW_SECTION+="${VAR_NAME}=${VALUE}\n"
done < "$REPO_DIR/vault.config"

if [ -z "$NEW_SECTION" ]; then
    exit 0
fi

tmpfile=$(mktemp)
LINE=$(grep -n "$MARKER" "$REPO_DIR/.env" | cut -d: -f1)

if [ -z "$LINE" ]; then
    cat "$REPO_DIR/.env" > $tmpfile
    printf "\n%s\n" "$MARKER" >> $tmpfile
else
    head -n "$LINE" "$REPO_DIR/.env" > $tmpfile
fi

printf "%b" "$NEW_SECTION" >> $tmpfile

cat $tmpfile > "$REPO_DIR/.env"

echo "Arquivo .env atualizado com sucesso."