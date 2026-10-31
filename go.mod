// This module is never built on its own. It exists so Dependabot has a Go modules
// manifest to read: the Dockerfile resolves these two versions with `go list` and
// passes them to xcaddy, so a Dependabot bump here changes the compiled image
// instead of being a no-op.
module github.com/saerlaith/personal-caddy

go 1.24

require (
	github.com/caddy-dns/cloudflare v0.2.1
	github.com/mholt/caddy-dynamicdns v0.0.0-20251020155855-d8f490a28db6
)
