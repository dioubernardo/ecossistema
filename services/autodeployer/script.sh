#!/bin/sh

git config --global --add safe.directory /repo

while true; do
    
    git fetch origin
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo '>> Atualização detectada, fazendo pull e redeploy...'

        if ! git diff-index --quiet HEAD --; then
            echo "Modificações locais detectadas, abortando atualização !!"
        else
            git pull && \
            docker compose pull && \
            docker compose build --pull && \
            docker compose up -d --remove-orphans
        fi
    fi

    sleep ${AUTODEPLOY_INTERVAL:-300} 
done