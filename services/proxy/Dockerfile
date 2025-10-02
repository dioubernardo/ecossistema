FROM traefik:v3.0 AS develop

VOLUME /certs

RUN apk add --no-cache openssl

COPY mkcert.sh /usr/local/bin/mkcert.sh
RUN chmod +x /usr/local/bin/mkcert.sh

ENTRYPOINT ["/usr/local/bin/mkcert.sh"]

CMD ["traefik"]

FROM traefik:v3.0 AS release
FROM traefik:v3.0 AS main
