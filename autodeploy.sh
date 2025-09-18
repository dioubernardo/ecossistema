#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

git config --global --add safe.directory "$DIR"

git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

# modificados + staged + untracked
LOCAIS_MODIFICADOS=$( \
    (git diff --name-only; \
     git diff --name-only --cached; \
     git ls-files --others --exclude-standard\
    ) | sort -u )

if [ "$LOCAL" = "$REMOTE" ]; then
    if [ "$LOCAIS_MODIFICADOS" != "" ]; then
        date
        echo "Modificações locais detectadas, isso irá gerar problemas nas próximas atualizações !!"
        echo $LOCAIS_MODIFICADOS
    fi
else
    echo 'Atualização detectada, fazendo pull e redeploy...'
    if [ "$LOCAIS_MODIFICADOS" != "" ]; then
        date
        echo "Modificações locais detectadas, abortando atualização !!"
        echo $LOCAIS_MODIFICADOS
    else
        git pull && \
        docker compose pull && \
        docker compose build --pull && \
        docker compose up -d --remove-orphans
    fi
fi
