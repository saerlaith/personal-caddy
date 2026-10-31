// This module is never built on its own. It exists so Dependabot has a Go modules
// manifest to read: the Dockerfile resolves these two versions with `go list` and
// passes them to xcaddy, so a Dependabot bump here changes the compiled image
// instead of being a no-op.
module github.com/saerlaith/personal-caddy

go 1.24
