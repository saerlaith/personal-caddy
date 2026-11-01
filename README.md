# personal-caddy

Personal Caddy image with modules: the Cloudflare DNS and dynamic-DNS plugins the
`reverseproxy` stack in `saerlaith/portainer-docker-compose` needs.

## How the image is pinned

The `Dockerfile` takes the Caddy version from its own `FROM` line; a workflow step
reads that line and tags the image `2.11.6`, `2.11.6-alpine`, `2`, `2-alpine`,
`latest` and `:<sha>`. Dependabot bumps the base image.

The two xcaddy plugin versions live in `go.mod`. The build resolves each one with
`go list` and passes it to `xcaddy --with`, so a Dependabot bump there reaches the
compiled image instead of being decorative.

**`tools.go` is what keeps those requirements in `go.mod`.** Nothing in this module
imports the plugins, so `go mod tidy` prunes both — and Dependabot's gomod updater
runs the same resolution. That is how PR #4 turned a version bump into a
deletion-only commit that emptied the file: the build lost its pins and stopped
publishing. Delete `tools.go` and the next Dependabot bump does it again.

## Building and publishing

Pull requests build the image without publishing. A push to `main`, the weekly
schedule and manual *Deploy to GHCR* dispatch publish to
`ghcr.io/saerlaith/personal-caddy`, using the `GHCR_TOKEN` secret, which needs
`write:packages`.

## Rolling out a new image

Nothing here updates the cluster. The `reverseproxy` stack pins this image as
`latest@sha256:<digest>`, so bump that digest in
`saerlaith/portainer-docker-compose` to deploy a new build.
