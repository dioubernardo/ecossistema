FROM alpine:latest

RUN apk add --no-cache tzdata curl supercronic

WORKDIR /app

COPY crontab crontab

CMD ["/usr/bin/supercronic", "-no-reap", "-quiet", "/app/crontab"]
