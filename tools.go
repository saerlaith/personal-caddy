//go:build tools

// This file is never compiled. It exists so `go mod tidy` - and therefore
// Dependabot's gomod updater - keeps the two xcaddy plugin requirements in
// go.mod: tidy only retains modules whose packages something imports, and nothing
// else in this module imports them.
//
// Without it, Dependabot prunes the requirements rather than bumping them. That is
// what happened in PR #4: "Bump github.com/caddy-dns/cloudflare from 0.2.1 to
// 0.2.4" was a deletion-only commit that removed both requirements and added
// nothing, which left the Dockerfile's `go list -m` with no version to resolve.
package tools

import (
	_ "github.com/caddy-dns/cloudflare"
	_ "github.com/mholt/caddy-dynamicdns"
)
