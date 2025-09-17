FROM docker:cli

WORKDIR /repo

RUN apk add --no-cache git bash

COPY script.sh /tmp/script.sh

CMD ["sh", "/tmp/script.sh"]
