# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.398"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.398/llmman-aarch64-apple-darwin"
    sha256 "27791664a9bb40526ae50f570525e17cbd6e13c4f462136999c88c39d97de4db"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.398/llmman-x86_64-unknown-linux-gnu"
      sha256 "caa124b94cde1fe9991f1b1001c03a661eb1a041cae0afc2ba17cf17e7acee73"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.398/llmman-aarch64-unknown-linux-gnu"
      sha256 "807f8865cc69cd4926492f7598e2a340de0f411f55ddd0f1799699f596741c66"
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
