FROM caddy:2-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare
    --with github.com/mholt/caddy-dynamicdns

FROM caddy:2-alpine

RUN apk add curl
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
