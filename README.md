# llmmanorg/homebrew-tap

Homebrew tap for [llmman](https://github.com/llmmanorg/llmman) — run any
coding agent on any model.

## Install

```sh
brew tap llmmanorg/tap
brew trust llmmanorg/tap
brew install llmman
```

The `brew trust` step is required because current Homebrew refuses to
load formulae from third-party taps until you explicitly trust them;
without it, `brew install` stops with `Refusing to load formula ... from
untrusted tap`.

Supported platforms (these are the platforms llmman publishes builds for):

| Platform | Architecture |
|---|---|
| macOS | Apple Silicon (`arm64`) |
| Linux | `x86_64` |
| Linux | `aarch64` |

Intel macOS is not supported — llmman publishes no `x86_64-apple-darwin`
build. Build from source instead; see the main repo's README.

## Tracking `main` instead of releases

`llmman` follows stable `v*` releases. To instead track every commit that
passes CI on `main` — the same channel `install.sh` uses — install
`llmman-dev`:

```sh
brew install llmman-dev
```

The two are separate formulae on purpose: Homebrew orders upgrades by
comparing version strings, and the two channels' versions are not
mutually comparable, so a single formula serving both would let one
permanently shadow the other. Install one or the other, not both.

## These formulae are generated

Both formulae are rendered by
[`packaging/render.sh`](https://github.com/llmmanorg/llmman/blob/main/packaging/render.sh)
in the main repo and pushed here by its CI on every release. **Edits made
directly in this repo are overwritten by the next release** — change
`packaging/homebrew/llmman.rb.in` upstream instead.
