FROM traefik:v3.5 AS develop

VOLUME /certs

RUN apk add --no-cache openssl

COPY mkcert.sh /usr/local/bin/mkcert.sh
RUN chmod +x /usr/local/bin/mkcert.sh

ENTRYPOINT ["/usr/local/bin/mkcert.sh"]

CMD ["traefik"]

FROM traefik:v3.5 AS release

VOLUME /certs

FROM release AS main
