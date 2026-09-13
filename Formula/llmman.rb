# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.406"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.406/llmman-aarch64-apple-darwin"
    sha256 "ed1ae4c3562240448fef147d13895f07103a7b9316e82fb6c60c38891fd3935b"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.406/llmman-x86_64-unknown-linux-gnu"
      sha256 "740da6f4cc1fc8c8edb4ce66b94f71c7a96496e4701ab115864545a3737b398b"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.406/llmman-aarch64-unknown-linux-gnu"
      sha256 "bf2d093ceb314988271e225e5693fa10f3f69f10a544102384d7b0a99bfafcb1"
    end
  end

  def install
    # The staged file keeps its llmman-<triple> asset name.
    bin.install Dir["llmman-*"].first => "llmman"
  end

  test do
    # CI writes this version into Cargo.toml before building, so the
    # binary reports it.
    assert_match version.to_s, shell_output("#{bin}/llmman --version")
    # `--version` is handled by clap before any llmman code runs; `list`
    # against an empty store exercises the storage layer and must exit 0
    # with no rows.
    assert_empty shell_output("#{bin}/llmman list").strip
  end
end
