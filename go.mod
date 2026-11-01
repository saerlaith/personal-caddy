// This module is never built on its own. It exists so Dependabot has a Go modules
// manifest to read: the Dockerfile resolves these two versions with `go list` and
// passes them to xcaddy, so a Dependabot bump here changes the compiled image
// instead of being a no-op.
//
// Nothing in the module imports either package, so `go mod tidy` prunes both of
// these requirements unless tools.go imports them behind the `tools` build tag.
// Do not delete that file: without it a Dependabot bump removes the pins instead
// of raising them, which is what PR #4 did.
module github.com/saerlaith/personal-caddy

go 1.24

require (
	github.com/caddy-dns/cloudflare v0.2.4
	github.com/mholt/caddy-dynamicdns v0.0.0-20251020155855-d8f490a28db6
)
