FROM caddy:2.11.6-builder-alpine AS builder

# The two xcaddy plugin versions live in go.mod, which Dependabot reads. Copying it
# in and resolving each version with `go list` makes go.mod the single source of
# truth: a Dependabot bump changes go.mod, the build picks the new version up, and
# the pin cannot drift from what is actually compiled.
COPY go.mod /pins/go.mod

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@$(go list -C /pins -m -f '{{.Version}}' github.com/caddy-dns/cloudflare) \
    --with github.com/mholt/caddy-dynamicdns@$(go list -C /pins -m -f '{{.Version}}' github.com/mholt/caddy-dynamicdns)

FROM caddy:2.11.6-alpine

RUN apk add curl
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
