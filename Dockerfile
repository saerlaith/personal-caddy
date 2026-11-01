FROM caddy:2.11.6-builder-alpine AS builder

# The two xcaddy plugin versions live in go.mod, which Dependabot reads. Copying it
# in and resolving each version with `go list` makes go.mod the single source of
# truth: a Dependabot bump changes go.mod, the build picks the new version up, and
# the pin cannot drift from what is actually compiled.
#
# tools.go is what keeps those two requirements in go.mod at all - nothing in the
# module imports the plugins, so `go mod tidy` would prune them without it.
#
# Each version is resolved into a variable first, and the whole step runs under
# `set -eu`. The previous one-liner had no `set -e`, so a failing `go list` left the
# substitution empty and handed xcaddy `--with <module>@`, which either failed
# obscurely or floated to @latest with nothing in the log saying the pin was lost.
#
# `-mod=mod` lets the go command write the checksum entries this throwaway directory
# has no go.sum for. With the requirement present it reports exactly the version
# go.mod pins, so the flag cannot move the pin itself.
COPY go.mod /pins/go.mod

RUN set -eu; \
    cloudflare="$(go list -C /pins -mod=mod -m -f '{{.Version}}' github.com/caddy-dns/cloudflare)"; \
    dynamicdns="$(go list -C /pins -mod=mod -m -f '{{.Version}}' github.com/mholt/caddy-dynamicdns)"; \
    echo "xcaddy plugins: caddy-dns/cloudflare@${cloudflare} mholt/caddy-dynamicdns@${dynamicdns}"; \
    xcaddy build \
        --with github.com/caddy-dns/cloudflare@${cloudflare} \
        --with github.com/mholt/caddy-dynamicdns@${dynamicdns}

FROM caddy:2.11.6-alpine

RUN apk add curl
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
